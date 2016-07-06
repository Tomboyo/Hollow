require_relative 'ResourceInterface'

class ResourceExample < ResourceInterface
  
  def self.get
    return "ResourceExample::GET"
  end
  
  def initialize(id)
    @id = id
  end
  
  def get
    return @id
  end
end