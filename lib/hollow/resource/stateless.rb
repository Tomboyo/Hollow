require 'singleton'

module Hollow
  module Resource

    # (see Hollow::Resource)
    #
    # Any resource which is thread-safe and does not store information between
    # requests should prefer Stateless to {Hollow::Resource::Stateful}.
    # Stateless automatically includes {Singleton} to the targeted class;
    # the singleton instance handles all requests from {Hollow::Application}.
    # Note that as a consequence of including Singleton, `instance()` is defined
    # on the marked class.
    #
    # @see Hollow::Resource::Stateful
    module Stateless
    private
      def self.extended(base)
        unless base.is_a?(Hollow::Resource)
          base.extend(Hollow::Resource)
        end

        unless base.is_a?(Singleton)
          base.include(Singleton)
        end
      end

      def self.included(base)
        fail "Hollow::Resource::Stateless should be extended"
      end
    end

  end
end
