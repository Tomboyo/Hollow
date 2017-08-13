require 'sandbox'
require 'sinatra'
require 'sinatra/multi_route'

ROUTES = %w(get post)

application = Sandbox::Application.new({
  autorequire: {
    root: "#{File.dirname __FILE__}", # This directory is the application root
    directories: ['resources']        # Resource types are in ./resouces
  },
  resource_methods: ROUTES # Only handle these requests; deny all others
});

route *ROUTES, '/:resource' do |resource|

  # Pass the request on to our resources!
  begin
    application.handle_request(
      resource: resource,
      method: request.request_method,
      data: {
        # Package up the request data in the format our resources expect
        data: {
          name: request["name"]
        }
      }
    )
  rescue Sandbox::ResourceException => e
    # User-safe error message
    "Can not handle request: #{e.message}"
  rescue Exception => e
    backtrace = e.backtrace.reduce("") { |memo, s| memo + "\n" + s }
    puts backtrace
    "Encountered an unexpected error while handling request."
  end
end
