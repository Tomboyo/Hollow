class BResource
  include Hollow::Resource::Stateless

  def get(*args)
    "B"
  end
end
