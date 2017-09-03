# Hollow

> Hollow is a drop-in component for building RESTful services that bridges from any routing solution (like Sinatra) to your back-end. You flesh out your service with Resource classes, you pick a Router to forward some traffic to Hollow, and it works. GET /HelloWorld becomes HelloWorld.get().

With Hollow, any class which includes `Hollow::Resource::Stateless` or `Stateful` is a REST resource capable of servicing certain kinds of requests. Let's say we want to respond to POST requests with a greeting like, "Hello, Tomboyo!":

```ruby
class HelloWorld
  include Hollow::Resource::Stateless
  def post(request)
    if (request['name'] && !request['name'].empty?)
      "Hello, #{request['name']}!"
    else
      "Hello, whoever you are!"
    end
  end
end
```

We save that to `./resources/HelloWorld.rb`. Now we want to expose it to the world, so we make a `./server.rb` script. Using Hollow, we first create an `Application` object:

```ruby
my_app = Hollow::Application.new(
  autorequire: {
    root: "#{File.dirname __FILE__}",
    directories: ['resources']
  },
  resource_methods: %i(post)
)
```
The application instance is configured to look for resources in `./resources`, which is where `HelloWorld` is defined. We've also decided that we only want to handle POST requests for now. Finally, we simply pipe HTTP traffic to the application’s `handle_request` method. Using Sinatra:

```ruby
post '/:resource' do |resource|
  begin
    my_app.handle_request(
      resource: resource,
      method:   request.request_method,
      data:     request.params
    )
  rescue Hollow::HollowException => e
    puts "Usage: POST /HelloWorld?name=your_name"
    puts e.message
  rescue
    puts "503!"
  end
end
```
Start the server and `curl "http://localhost:4567/HelloWorld" -X POST -d"name=Tomboyo"` to be given an enthusiastic greeting (that is, send a post request with your name). If we want to create any more functionality, we just create new classes where Hollow can find them. That's it!

# What about other classes and methods?

Only classes, and only classes which include `Hollow::Resource::Stateless` or `Hollow::Resource::Stateful` can service requests. Only resource methods matching the symbols configured via the `resource_methods: %i(post)` parameter during application instantiation can be invoked, as well; other methods are hidden. That means if you only make a `HelloWorld` resource and your application only has `post` configured, your application only invokes `HelloWorld`'s `post`. Nothing else, ever.

# Is this only for REST?

Hollow was designed for REST, but it's not limited in that respect. `Application` can be configured with nonstandard request methods (making resource.myRequestMethodHere a legal request handler), so really `Application` is a mapping from binary identifiers (HelloWorld, post) to methods (HelloWorld post(resource)).
