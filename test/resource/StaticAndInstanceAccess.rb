class StaticAndInstanceAccess
  include ResourceInterface # /resource/id requests allowed
  extend ResourceInterface  # /resource requests allowed

  def initialize(id)
    @id = id
  end

  def self.get(query = nil, data = nil)
    return "::GET"
  end

  def get(query = nil, data = nil)
    return @id
  end
end
