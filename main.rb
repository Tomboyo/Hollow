require 'sinatra'
require 'sinatra/multi_route'
require 'json'

require_relative('lib/Autoloader')

register Sinatra::MultiRoute

debug = true
autoloader = Autoloader.new(File::expand_path('..', __FILE__))
autoloader.require_files_in('lib')
autoloader.require_files_in('resource')

include Helper
  
# Requests to Resource classes
route :get, :post, :put, :patch, :delete, :options, '/:resource/?:id?' do |res, id|
  process_request(lambda {
    # If the class isn't required already, it isn't a resource.
    raise ResourceInvalidError.new unless Object.const_defined?(res)
    
    method = request.request_method.downcase.to_sym

    resource = Object.const_get(res)
    raise ResourceInvalidError.new unless resource < ResourceInterface && resource.class != ResourceInterface
    
    unless id.nil?
      # Reference to instance of class
      resource = resource.new(id.to_i)
    end
    
    return {'data' => resource.public_send(method)}
  }, debug)
end

route :get, :post, :put, :patch, :delete, :options, '*' do
  process_request(lambda {
    return {'data' => 'get|post|put|patch|delete /:resource[/:id]'}
  }, debug)
end