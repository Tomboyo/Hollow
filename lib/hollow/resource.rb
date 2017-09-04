module Hollow

  # A mixin that marks a class as a hollow resource and defines the resource
  # API.
  #
  # Only instances of Resource can be accessed by
  # {Hollow::Application#handle_request}. This module should generally not be
  # extended directly, however, as {Stateful} and {Stateless} should suffice
  # for most use-cases. If not, be sure to override the unimplemented methods,
  # indicated below.
  module Resource

  public

    # Obtain an instance of the Resource implementation.
    #
    # Unless overridden, the default behavior is to fail; this is to indicate
    # that this method is part of the Resource API. Note that {Stateful} and
    # {Stateless} both override this method with meaningful behavior.
    def self.instance
      fail "#{self}#instance must be overridden"
    end

  private

    def self.extended(base)
      base.class_variable_set(:@@chains, {
        before: {},
        after:  {}
      })
    end

  end
end
