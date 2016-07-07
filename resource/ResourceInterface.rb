require_relative '../lib/AppExceptions'

# Default resource interface definition.
# Implementing classes should include and/or extend ResourceInterface depending
# on their functionality. If a resource will interface with a DB or otherwise
# contain information particular to certain records, use include. If a resource
# should instead (or alos) provide stateless functionality (static methods), use
# extend. If a resource fails to include or extend ResourceInterface, the system
# will prevent corresponding instance and static requests (/res/id, /res).
module ResourceInterface
  def get
    raise ResourceMethodInvalidError.new()
  end

  def post
    raise ResourceMethodInvalidError.new()
  end

  def put
    raise ResourceMethodInvalidError.new()
  end

  def patch
    raise ResourceMethodInvalidError.new()
  end

  def delete
    raise ResourceMethodInvalidError.new()
  end

  def options
    raise ResourceMethodInvalidError.new()
  end
end
