module Hollow
  module Resource

    # Marks a class as a {Hollow::Resource} that may be used by
    # {Hollow::Application} instances to handle requests. Each time
    # {Hollow::Application#handle_request} delegates to a Stateful resource, a
    # new instance of the resource is created to service the request.
    # @see Hollow::Resource::Stateless
    module Stateful
      private
      def self.included(base)
        unless base.is_a?(Hollow::Resource)
          base.extend(Hollow::Resource)
        end

        def base.get_instance
          self.new
        end
      end
    end

  end
end
