module Hollow
  module Resource

    module Chains
      def self.included(base)

        def base.chain(chain, method, behavior)
          (self.class_variable_get(:@@chains)[chain][method] ||= []) <<
              behavior
        end
      end
    end

  end
end
