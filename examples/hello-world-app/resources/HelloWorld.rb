# Hollow will automatically forward requests like GET /HelloWorld to this class.
class HelloWorld
  include Hollow::Resource::Stateless

  def get(request)
    "Hello World!"
  end

  def post(request)
    if (request['name'] && !request['name'].empty?)
      "Hello, #{request['name']}!"
    else
      "Hello, whoever you are!"
    end
  end

end
