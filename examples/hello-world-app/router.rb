require 'sandbox'
require 'sinatra'

ROUTES = %w(get post)

application = Sandbox::Application.new({
  autorequire: {
    root: "#{File.dirname __FILE__}", # This directory is the application root
    directories: ['resources']        # Resource types are in ./resouces
  },
  resource_methods: ROUTES # Only handle these requests; deny all others
});

route *ROUTES, '*' do
  # Format request data to match what our Resource expects
  app_request = {
    data: {
      name: request["name"]
    }
  }

  # Pass the request on to our resources!
  application.handle_request(app_request)
end
