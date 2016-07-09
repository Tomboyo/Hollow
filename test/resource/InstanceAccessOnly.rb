# This resource can only be accessed as an instance (with a valid record id)
class InstanceAccessOnly
  include ResourceInterface

  def initialize id
    @id = id
  end

  def get
    return @id
  end
end
