require 'sinatra'
require 'sinatra/multi_route'
require 'json'

require_relative('lib/Autoloader')

register Sinatra::MultiRoute

debug = true
autoloader = Autoloader.new(File::expand_path('..', __FILE__))
autoloader.require_files_in('lib')
autoloader.require_files_in('resource')

allowed_routes = [:get, :post, :put, :patch, :delete, :options]

include Helper

# Requests to Resource classes
route *allowed_routes, '/:resource/?:id?' do |res, id|
  process_request(lambda {
    # If the class isn't required already, it isn't a resource.
    raise ResourceInvalidError.new unless Object.const_defined?(res) &&
      Object.const_get(res).is_a?(Class)

    resource = Object.const_get(res)

    if id.nil?
      # verify that resource extends the interface
      raise ResourceInvalidError.new unless resource.is_a?(ResourceInterface) &&
        resource.class != ResourceInterface
    else
      # verify that resource includes the interface
      raise ResourceInvalidError.new unless resource.include? ResourceInterface
      resource = resource.new(id.to_i)
    end

    return {
      data: resource.public_send(request.request_method.downcase.to_sym)
    }
  }, debug)
end

route *allowed_routes, '*' do
  process_request(lambda {
    return { data: 'get|post|put|patch|delete /:resource[/:id]' }
  }, debug)
end
