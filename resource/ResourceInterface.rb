# Default resource interface definition.
# Implementing classes should include and/or extend ResourceInterface depending
# on their functionality. If a resource will interface with a DB or otherwise
# contain information particular to certain records, use include. If a resource
# should instead (or alos) provide stateless functionality (static methods), use
# extend. If a resource fails to include or extend ResourceInterface, the system
# will prevent corresponding instance and static requests (/res/id, /res).
module ResourceInterface
  $settings.resource_methods.each do |route|
    define_method(route) { raise ResourceMethodInvalidError.new }
  end
end
