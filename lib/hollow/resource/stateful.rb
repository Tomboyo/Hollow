module Hollow
  module Resource

    # (see Hollow::Resource)
    #
    # Resources which are not thread-safe or which save state between requests
    # must include Stateful as opposed to {Hollow::Resource::Stateless}. the
    # `instance()` method is defined on the marked class, which by default
    # creates a new instance of the class on each request. Each time
    # {Hollow::Application#handle_request} delegates to a Stateful resource, a
    # new instance of the resource is therefore created to service
    # the request. This behavior can and should be overridden as desired.
    #
    # @see Hollow::Resource::Stateless
    module Stateful
    private
      def self.extended(base)
        unless base.is_a?(Hollow::Resource)
          base.extend(Hollow::Resource)
        end
      end

      def self.included(base)
        fail "Hollow::Resource::Stateful should be extended"
      end

    public
      def instance
        self.new
      end
    end

  end
end
