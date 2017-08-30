require 'require_all'

module Hollow

  class Application

    # Indicates an illegal resource name.
    class ResourceException < Hollow::HollowException
      # The illegal resource name.
      attr_reader :resource_name

      private
      def initialize(resource_name)
        super("The resource #{resource_name} does not exist.")
        @resource_name = resource_name
      end
    end

    # Indicates an illegal resource method name.
    class ResourceMethodException < Hollow::HollowException
      # The legal resource name provided for the request.
      attr_reader :resource_name

      # The illegal method name.
      attr_reader :method_name

      private
      def initialize(resource_name, method_name)
        super("The %s resource does not respond to %s requests" % [
            resource_name,
            method_name
        ])

        @resource_name = resource_name
        @method_name = method_name
      end
    end

    attr_reader :settings

    def initialize(settings = {})
      @settings = Hollow::DEFAULT_SETTINGS.merge(settings)
      @settings[:resource_methods].map! { |m| m.to_sym }
      @settings[:autorequire][:directories].each do |dir|
        require_all "#{@settings[:autorequire][:root]}/#{dir}"
      end
    end

    def handle_request(resource: nil, method: nil, data: {})
      begin
        resource_class = Application::get_resource(resource.to_sym)
        handler = resource_class.get_instance
        method = method.to_sym.downcase
      rescue NoMethodError, NameError
        fail ResourceException.new resource
      end

      if @settings[:resource_methods].include?(method) &&
          handler.respond_to?(method)
        invoke_chain(resource_class, data, :before, method)
        response = handler.public_send(method, data)
        invoke_chain(resource_class, data, :after, method)
        return response
      else
        fail ResourceMethodException.new resource, method
      end
    end

    private
    def Application::get_resource(resource)
      if Module.const_defined?(resource)
        it = Object.const_get(resource)

        if it.is_a?(Class) &&
            it.class != Hollow::Resource &&
            it.is_a?(Hollow::Resource)
          return it
        else
          fail ResourceException.new resource
        end
      end
    end

    def invoke_chain(resource, request, chain, method)
      chains = resource.class_variable_get(:@@chains)
      links = (chains[chain][:all] || []) + (chains[chain][method] || [])
      links.each { |chain_link| chain_link.call(request) }
    end
  end

end
