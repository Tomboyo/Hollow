# This resource can only be accessed statically (without a record id)
class StaticAccessOnly
  extend ResourceInterface

  def self.get
    return '::GET'
  end
end
