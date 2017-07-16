class AResource
  extend Sandbox::Resource
  def self.getHandler
    self.new
  end

  def get(*args)
    "A"
  end
end
