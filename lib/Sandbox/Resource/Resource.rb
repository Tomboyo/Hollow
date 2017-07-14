# A mixin that marks a class as a Resource.
module Sandbox
  module Resource ; end
  def getHandler
    raise ResourceException, "No implementation of getHandler defined"
  end
end
