# This resource can only be accessed statically (without a record id)
class StaticAccessOnly
  extend ResourceInterface

  def self.get(query = nil, data = nil)
    return '::GET'
  end
end
