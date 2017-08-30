require 'require_all'

module Hollow

  # A RESTful service provider framework which provides dynamic access to REST
  # resource objects, allowing routers to service reqeusts without any knowledge
  # of the types that exist in business code.
  #
  # - Resource classes compose the service provider aspect of Hollow and
  # encapsulate all or part of a system's business logic.
  # - Any class can be registered as a resource by including one of the
  # Stateless[Resource/Stateless] or Stateful[Resource/Stateful] modules.
  # - The service provider API is defined dynamically by application instance
  # configuration (see settings[Application#settings-instance_method]).
  # Different application instances can use the same underlying resources, but
  # they will filter access to those resources differently. Requests through one
  # application instance may succeed while requests through another may raise
  # access exceptions.
  # - Application instances provide service access to resources via the
  # handle_request[#handle_request] method.
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

    # @return [Hash] the application settings
    attr_reader :settings

    # Create a new application instance.
    # @param [Hash] settings application settings. See
    #   {Hollow::DEFAULT_SETTINGS} for defaults.
    # @option settings [Array<Symbol>, Array<String>] :resource_methods
    #   Resource method names which may be invoked on resource instances by
    #   this application. This effectively defines the service provider API.
    # @option settings [String] :autorequire[:root]
    #   location in the file system relative to which other filesystem locations
    #   are evaluated.
    # @option settings [Array<String>] :autorequire[:directories]
    #   file system locations where resource classes may be found; all classes
    #   in these directories will be required immediately. These locations are
    #   relative to `:autorequire[:root]`.
    def initialize(settings = {})
      @settings = Hollow::DEFAULT_SETTINGS.merge(settings)
      @settings[:resource_methods].map! { |m| m.to_sym }
      @settings[:autorequire][:directories].each do |dir|
        require_all "#{@settings[:autorequire][:root]}/#{dir}"
      end
    end

    # Attempt to invoke a resource method with the given data.
    #
    # @param [String, Symbol] resource
    #   The case-sensitive name of a desired resource.
    # @param [String, Symbol] method
    #   The case-sensitive resource method name to invoke.
    # @param [Hash] data
    #   Any data which the resource may or may not use to handle the reqeust.
    # @raise [Hollow::ResourceException]
    #   If the indicated resource is not defined, is not a Class, is
    #   {Hollow::Resource} itself, or is not a type of {Hollow::Resource}.
    # @raise [Hollow::ResourceMethodException]
    #   If the indicated resource exists and:
    #     1. The indicated method is not accessible or defined, or
    #     2. The method name is not included in `settings[:resource_methods]`.
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
