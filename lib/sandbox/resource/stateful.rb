module Sandbox
  module Resource

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
