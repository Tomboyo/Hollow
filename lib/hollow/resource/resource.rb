module Hollow

  # A mixin that marks a class as a Resource.
  module Resource

    def self.extended(base)
      base.class_variable_set(:@@chains, {
        before: {},
        after:  {}
      })
    end

  end
end
