class BResource
  extend Sandbox::Resource
  def self.getHandler
    self.new
  end

  def get(*args)
    "B"
  end
end
