module Hollow
  module Resource

    # A Resource which keeps state between requests.
    #
    # Resources which are not thread-safe or which save state between requests
    # should extend Stateful as opposed to {Stateless}.
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

      # Obtain an instance of the Resource implementation.
      #
      # Stateful types will return a new object upon each request. You may wish
      # to override this behavior, such as to leverage a pooling mechanism.
      def instance
        self.new
      end
    end

  end
end
