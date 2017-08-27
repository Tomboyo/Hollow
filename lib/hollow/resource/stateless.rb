module Hollow
  module Resource

    # Marks a class as a {Hollow::Resource} that may be used by
    # {Hollow::Application} instances to handle requests. Including this module
    # creates a singleton instance of the class which will service all requests
    # from all Application instances.
    # @see Hollow::Resource::Stateful
    module Stateless
      def self.included(base)
        unless base.is_a?(Hollow::Resource)
          base.extend(Hollow::Resource)
        end

        base.class_variable_set(:@@instance, base.new)
        def base.get_instance
          self.class_variable_get(:@@instance)
        end
      end
    end

  end
end
