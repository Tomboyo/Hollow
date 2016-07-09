class StaticAndInstanceAccess
  include ResourceInterface # /resource/id requests allowed
  extend ResourceInterface  # /resource requests allowed

  def initialize(id)
    @id = id
  end

  def self.get
    return "::GET"
  end

  def get
    return @id
  end
end
