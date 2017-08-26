require_relative "hollow/application"
require_relative "hollow/exceptions"
require_relative "hollow/resource"
require_relative "hollow/version"
require_relative "hollow/resource/chains"
require_relative "hollow/resource/stateful"
require_relative "hollow/resource/stateless"

module Hollow
  DEFAULT_SETTINGS = {
    autorequire: {
      root: "#{File.dirname __FILE__}/../..",
      directories: []
    },
    resource_methods: ["get", "post", "put", "patch", "delete", "options"]
  }
end
