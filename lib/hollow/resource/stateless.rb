require 'singleton'

module Hollow
  module Resource

    # A Resource which keeps no state between requests.
    #
    # Any resource which is thread-safe and does not store information between
    # requests should prefer Stateless to {Stateful}.
    #
    # Stateless automatically includes Singleton to the targeted class.
    # Singleton::instance supplies the implementation for {Resource}::instance.
    #
    # @see Hollow::Resource::Stateful
    module Stateless
    private
      def self.extended(base)
        unless base.is_a?(Hollow::Resource)
          base.extend(Hollow::Resource)
        end

        base.include Singleton
      end

      def self.included(base)
        fail "Hollow::Resource::Stateless should be extended"
      end
    end

  end
end
