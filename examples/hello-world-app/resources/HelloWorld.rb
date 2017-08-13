class HelloWorld
  include Sandbox::Resource::Stateless

  def get(request)
    "Hello World!"
  end

  def post(request)
    if (request[:data][:name] && !request[:data][:name].empty?)
      "Hello, #{request[:data][:name]}!"
    else
      "Hello, whoever you are!"
    end
  end

end
