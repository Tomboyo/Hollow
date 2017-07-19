module Sandbox

  # A mixin that marks a class as a Resource.
  module Resource

    # A resource that handles all requests with the same instance
    module Stateless
      def self.included(base)
        unless base.is_a?(Sandbox::Resource)
          base.extend(Sandbox::Resource)
        end

        base.class_variable_set(:@@instance, base.new)
        def base.get_instance
          self.class_variable_get(:@@instance)
        end
      end
    end

    # A resource which handles each request with a new instance
    module Stateful
      def self.included(base)
        unless base.is_a?(Sandbox::Resource)
          base.extend(Sandbox::Resource)
        end

        def base.get_instance
          self.new
        end
      end
    end
  end
end
