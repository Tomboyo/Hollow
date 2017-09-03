require 'hollow'
require "sinatra"
require "sinatra/multi_route"

hollow_app = Hollow::Application.new(
  autorequire: {
    root: "#{File.dirname __FILE__}", # This directory is the application root
    directories: ['resources']        # Resource types are in ./resouces
  },
  # Only handle these requests; deny all others
  resource_methods: %i(get post put)
)

# Forward get, post, and put requests to hollow.
route *%i(get post put), "/:resource" do |resource|
  begin
    hollow_app.handle_request(
      resource: resource,
      method:   request.request_method,
      data:     request.params
    )
  rescue Hollow::HollowException => e
    puts e.message
  rescue
    puts "An unexpected error occurred!"
  end
end
