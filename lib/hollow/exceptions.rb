module Hollow

  class HollowException < StandardError ; end
  class ResourceException < HollowException ; end
  class ResourceMethodException < ResourceException ; end

end
