require 'sandbox'
require 'sinatra'
require 'sinatra/multi_route'

ROUTES = %i(get post)

application = Sandbox::Application.new(
  autorequire: {
    root: "#{File.dirname __FILE__}", # This directory is the application root
    directories: ['resources']        # Resource types are in ./resouces
  },
  resource_methods: ROUTES # Only handle these requests; deny all others
)

route *ROUTES, '/:resource' do |resource|
  # Pass the request on to our resources!
  begin
    application.handle_request(
      resource: resource,
      method: request.request_method,
      data: request.params
    )
  rescue Sandbox::SandboxException => e
    # User-safe error message
    "Could not handle request: #{e.message}"
  rescue Exception => e
    puts e.backtrace.reduce("#{e.message}") { |memo, s| memo + "\n" + s }
    "Encountered an unexpected error while handling request."
  end
end
