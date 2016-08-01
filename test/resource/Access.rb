# This resource can only be accessed statically (without a record id)
class Access
  extend ResourceInterface

  def self.get(query = nil, data = nil)
    return '::GET'
  end

  def get()
    return 5
  end
end
