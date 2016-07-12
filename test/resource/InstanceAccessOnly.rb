# This resource can only be accessed as an instance (with a valid record id)
class InstanceAccessOnly
  include ResourceInterface

  def initialize id
    @id = id
  end

  def get(query = nil, data = nil)
    return @id
  end
end
