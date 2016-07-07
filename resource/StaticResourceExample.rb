require_relative 'ResourceInterface'

# This resource can only be accessed statically (without a record id)
class StaticResourceExample
  extend ResourceInterface

  def get
    return 'StaticResourceExample::GET'
  end
end
