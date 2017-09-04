class BResource
  extend Hollow::Resource::Stateless

  def get(*args)
    "B"
  end
end
