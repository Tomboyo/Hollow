class AResource
  include Hollow::Resource::Stateless

  def get(*args)
    "A"
  end
end
