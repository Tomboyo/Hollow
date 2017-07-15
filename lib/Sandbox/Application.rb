require 'require_all'
require_relative 'Resource/Resource'
require_relative 'exceptions'

module Sandbox

  class Application

    DEFAULT_SETTINGS = {
      autorequire: {
        root: "#{File.dirname __FILE__}/../..",
        directories: ["resources"]
      },
      resource_methods: ["get", "post", "put", "patch", "delete", "options"]
    }

    def initialize(settings = {})
      @settings = DEFAULT_SETTINGS.merge(settings)
      @settings[:resource_methods].map! { |m| m.to_sym }
      @settings[:autorequire][:directories].each do |dir|
        require_all "#{@settings[:autorequire][:root]}/#{dir}"
      end
    end

    def handle_request(resource, method, args = [])
      begin
        handler = Application::get_resource(resource.to_sym)
            .getHandler
        method = method.to_sym.downcase
      rescue NoMethodError, NameError
        raise Sandbox::ResourceException,
            "The resource #{resource} does not exist."
      end

      if @settings[:resource_methods].include?(method) &&
          handler.respond_to?(method)
        return handler.public_send(method, args)
      else
        raise Sandbox::ResourceMethodException,
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
          raise Sandbox::ResourceException,
              "The requested resource (\"#{resource}\") does not exist."
        end
      end
    end

  end

end
