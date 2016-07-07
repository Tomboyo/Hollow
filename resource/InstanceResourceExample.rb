require_relative 'ResourceInterface'

# This resource can only be accessed as an instance (with a valid record id)
class InstanceResourceExample
  include ResourceInterface

  def initialize id
    @id = id
  end

  def get
    return @id
  end
end
