require 'hollow'

class HelloWorld
  include Hollow::Resource::Stateless

  def get(data = {})
    "Hello, world!"
  end

  def put(data = {})
    "Hello, #{data["name"]}!"
  end

  def post(data = {})
    "#{data["greeting"]}, world!"
  end
end
