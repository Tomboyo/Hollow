module Hollow
  module Resource

    # Indicates that a {Hollow::Resource} class uses chains to perform logic
    # before or after each request.
    module Chains
      def self.included(base)

        # Register a function to invoke before or after a given resource method
        # (or any resource method) is invoked.
        #
        # Behaviors are invoked in the order in which they are defined within
        # their respective chains, the exception being that behaviors associated
        # with `:all` methods are invoked before more specific methods.
        #
        # @param [Symbol] chain
        #   Which chain to register the designated behavior with. Must be one of
        #   either `:before` or `:after`.
        # @param [Symbol] method
        #   Which request method triggers the behavior. If `:all` is provded,
        #   any request method will invoke the behavior.
        # @param [Proc, Lambda] behavior
        #   Behavior which accepts one argument (the data accompanying the
        #   current request).
        def base.chain(chain, method, behavior)
          (self.class_variable_get(:@@chains)[chain][method] ||= []) <<
              behavior
        end
      end
    end

  end
end
