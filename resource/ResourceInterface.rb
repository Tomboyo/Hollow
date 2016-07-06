=begin
  Provides default interfce for all resources.
=end

require_relative '../lib/AppExceptions'

class ResourceInterface
 
  #
  # Class methods (/:resource)
  #

  def self.get
    raise ResourceMethodInvalidError.new()
  end
  
  def self.post
    raise ResourceMethodInvalidError.new()
  end
  
  def self.put
    raise ResourceMethodInvalidError.new()
  end
  
  def self.patch
    raise ResourceMethodInvalidError.new()
  end
  
  def self.delete
    raise ResourceMethodInvalidError.new()
  end
  
  def self.options
    raise ResourceMethodInvalidError.new()
  end

  #
  # Instance methods (/:resource/:id)
  #

  def initialize
  end
  
  def get
    raise ResourceMethodInvalidError.new()
  end
  
  def post
    raise ResourceMethodInvalidError.new()
  end
  
  def put
    raise ResourceMethodInvalidError.new()
  end
  
  def patch
    raise ResourceMethodInvalidError.new()
  end
  
  def delete
    raise ResourceMethodInvalidError.new()
  end
  
  def options
    raise ResourceMethodInvalidError.new()
  end
end