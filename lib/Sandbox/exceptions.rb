module Sandbox

  class SandboxException < StandardError ; end
  class ResourceException < SandboxException ; end
  class ResourceMethodException < ResourceException ; end

end
