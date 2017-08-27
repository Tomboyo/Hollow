module Hollow

  # Base class for all Hollow exceptions.
  class HollowException < StandardError ; end

  # Indicates that a valid {Hollow::Resource} can not be found to handle a
  # request.
  class ResourceException < HollowException ; end

  # Indicates that a {Hollow::Resource} can not respond to a request because
  # the desired method is inaccessible or undefined.
  class ResourceMethodException < ResourceException ; end

end
