class BResource
  include Sandbox::Resource::Stateless

  def get(*args)
    "B"
  end
end
