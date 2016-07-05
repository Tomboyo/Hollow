=begin
  Provides default interfce for all resources.
=end

require_relative '../lib/AppExceptions'

module ResourceInterface
 
  #
  # Class methods (/:resource)
  #

  def self.get
    raise ResourceMethodUndefinedError.new()
  end
  
  def self.post
    raise ResourceMethodUndefinedError.new()
  end
  
  def self.put
    raise ResourceMethodUndefinedError.new()
  end
  
  def self.patch
    raise ResourceMethodUndefinedError.new()
  end
  
  def self.delete
    raise ResourceMethodUndefinedError.new()
  end
  
  def self.options
    raise ResourceMethodUndefinedError.new()
  end

  #
  # Instance methods (/:resource/:id)
  #

  def initialize
  end
  
  def get
    raise ResourceMethodUndefinedError.new()
  end
  
  def post
    raise ResourceMethodUndefinedError.new()
  end
  
  def put
    raise ResourceMethodUndefinedError.new()
  end
  
  def patch
    raise ResourceMethodUndefinedError.new()
  end
  
  def delete
    raise ResourceMethodUndefinedError.new()
  end
  
  def options
    raise ResourceMethodUndefinedError.new()
  end
end