class HelloWorld
  include Sandbox::Resource::Stateless

  def get(request)
    "Hello World!"
  end

  def post(request)
    "Hello #{request.data.name}"
  end

end
