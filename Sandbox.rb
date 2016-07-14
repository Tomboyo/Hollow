require 'sinatra/base'
require 'sinatra/multi_route'
require "sinatra/config_file"
require 'json'
require 'require_all'

class Sandbox < Sinatra::Base
  register Sinatra::MultiRoute
  register Sinatra::ConfigFile

  # Load configuration and require project files dynamically based on settings
  config_file 'config.yml'
  set(:root) { File.dirname __FILE__ }
  settings.resource_methods.map! { |m| m.to_sym }

  $settings = settings

  $settings.autorequire[:directories].each do |dir|
    require_all "#{$settings.root}#{dir}"
  end

  # Project-local includes, extends, etc. go here
  include Helper

  #
  # ROUTING
  #

  # Requests to ResourceInterfaces
  route *$settings.resource_methods, '/:resource/?:id?' do |res, id|
    process_request(lambda {
      # If the class isn't required already, it isn't a resource.
      begin
        raise ResourceInvalidException.new unless Object.const_defined?(res) &&
          Object.const_get(res).is_a?(Class)
      rescue NameError => e
        # bad case
        raise ResourceInvalidException.new
      end

      resource = Object.const_get(res)

      if id.nil?
        # verify that resource extends the interface
        raise ResourceInvalidException.new unless resource.is_a?(ResourceInterface) &&
          resource.class != ResourceInterface
      else
        # verify that resource includes the interface
        raise ResourceInvalidException.new unless resource.include? ResourceInterface
        resource = resource.new(id.to_i)
      end

      # Get the query string and request body parsed but unmodified.
      # We don't use Sinatra's parameters because they can be overridden by the
      # body.
      query_string = request.env["rack.request.query_string"]
      request.body.rewind
      begin
        data = request.body.eof? ? {} : JSON.parse(request.body.read)
      rescue => error
        return {error: "Request body should be valid JSON."}
      end

      # Method names are implicitly sanitized by the route parameters, so we can
      # safely pass the request off.
      return {
        data: resource.public_send(
          request.request_method.downcase.to_sym,
          query_string,
          data
        )
      }
    })
  end

  # Catchall usage message
  route *$settings.resource_methods, '*' do
    process_request(lambda {
      return { data: 'get|post|put|patch|delete /:resource[/:id]' }
    })
  end
end