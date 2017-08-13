require 'sinatra/base'
require 'sinatra/multi_route'

module Sandbox

  class SinatraRouter
    def initialize(settings = {})
      @application = Sandbox::Application.new(settings)

      # Application will have defaulted missing settings
      @settings = settings
    end

    route *@settings[:resource_methods], '/:resource' do |resource|
      begin
        @application.handle_request(
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
  end

end
