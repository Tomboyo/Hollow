# Default resource interface definition.
# Implementing classes should extend ResourceInterface depending.
# If a resource fails to extend ResourceInterface, the system
# will prevent access to the resource (/res/id, /res).
module ResourceInterface
  $settings.resource_methods.each do |route|
    define_method(route) do |*|
      raise ResourceMethodInvalidException.new
    end
  end
end
