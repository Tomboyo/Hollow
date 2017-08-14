require_relative "sandbox/application"
require_relative "sandbox/exceptions"
require_relative "sandbox/resource"
require_relative "sandbox/version"
require_relative "sandbox/resource/chains"
require_relative "sandbox/resource/stateful"
require_relative "sandbox/resource/stateless"

module Sandbox
  DEFAULT_SETTINGS = {
    autorequire: {
      root: "#{File.dirname __FILE__}/../..",
      directories: []
    },
    resource_methods: ["get", "post", "put", "patch", "delete", "options"]
  }
end
