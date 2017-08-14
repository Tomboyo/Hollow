require 'require_all'

module Sandbox

  class Application

    attr_reader :settings

    def initialize(settings = {})
      @settings = Sandbox::DEFAULT_SETTINGS.merge(settings)
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
        fail Sandbox::ResourceException,
            "The resource #{resource} does not exist."
      end

      if @settings[:resource_methods].include?(method) &&
          handler.respond_to?(method)
        invoke_chain(resource_class, data, :before, method)
        response = handler.public_send(method, data)
        invoke_chain(resource_class, data, :after, method)
        return response
      else
        fail Sandbox::ResourceMethodException,
            "The %s resource does not respond to %s requests" % [ resource,
                method ]
      end
    end

    private
    def Application::get_resource(resource)
      if Module.const_defined?(resource)
        it = Object.const_get(resource)

        if it.is_a?(Class) &&
            it.class != Sandbox::Resource &&
            it.is_a?(Sandbox::Resource)
          return it
        else
          fail Sandbox::ResourceException,
              "The requested resource (\"#{resource}\") does not exist."
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
