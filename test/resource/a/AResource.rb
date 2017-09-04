class AResource
  extend Hollow::Resource::Stateless

  def get(*args)
    "A"
  end
end
