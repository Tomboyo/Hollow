require 'sinatra/base'
require 'sinatra/multi_route'

module Hollow

  class SinatraRouterFactory

    # Create a new Sinatra router class which routes pertinent requests to the
    # passed-in Hollow application.
    # Sinatra will only know to handle the application-configured request
    # methods--If your application is set to handle get and post, the Sinatra
    # router won't service a Patch, even for a valid resource. You will see a
    # "doesn't know this ditty" in that case.
    def self.create_router_for(application)
      Class.new(Sinatra::Base) do
        register Sinatra::MultiRoute
        #set :show_exceptions, false
        set :raise_errors, false
        #set :dump_errors, false

        @@application = application

        methods = application.settings[:resource_methods]
        route *methods, '/:resource' do |resource|
          begin
            @@application.handle_request(
                resource: resource,
                method:   request.request_method,
                data:     request.params
            )
          rescue Hollow::HollowException => e
            # User-safe error message
            "Could not handle request: #{e.message}"
          rescue Exception => e
            "Encountered an unexpected error while handling request."
          end
        end

      end
    end

  end

end
