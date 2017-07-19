class AResource
  include Sandbox::Resource::Stateless

  def get(*args)
    "A"
  end
end
