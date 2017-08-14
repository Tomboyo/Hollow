require 'sinatra/base'
require 'sinatra/multi_route'

module Sandbox

  class SinatraRouterFactory
    #register Sinatra::MultiRouted

    public
    def self.create_router_for(application)
      Class.new(Sinatra::Base) do
        register Sinatra::MultiRoute
        set :show_exceptions, false
        set :raise_errors, false
        set :dump_errors, false

        @@application = application

        methods = application.settings[:resource_methods]
        route *methods, '/:resource' do |resource|
          begin
            @@application.handle_request(
                resource: resource,
                method:   request.request_method,
                data:     request.params
            )
          rescue Sandbox::SandboxException => e
            # User-safe error message
            "Could not handle request: #{e.message}"
          rescue Exception => e
            puts e.backtrace.reduce(e.message) { |memo, s| memo << "\n#{s}" }
            "Encountered an unexpected error while handling request."
          end
        end

      end
    end

  end

end
