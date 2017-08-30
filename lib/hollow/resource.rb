module Hollow

  # A mixin that marks a class as a resource. Only instances of Resource can be
  # accessed by {Hollow::Application#handle_request}. This module should not be
  # used directly; prefer {Hollow::Resource::Stateless} or
  # {Hollow::Resource::Stateful} instead.
  module Resource

    private
    def self.extended(base)
      base.class_variable_set(:@@chains, {
        before: {},
        after:  {}
      })
    end

  end
end
