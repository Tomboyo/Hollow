require 'sinatra'
require 'sinatra/multi_route'
require 'json'

require_relative('lib/Autoloader')

register Sinatra::MultiRoute

debug = false
autoloader = Autoloader.new(File::expand_path('..', __FILE__))
autoloader.require_files_in('lib')
autoloader.require_files_in('resource')

include Helper
  
# Requests to Resource classes
route :get, :post, :put, :patch, :delete, :options, '/:resource/?:id?' do |res, id|
  process_request(lambda {
    raise ApplicationError.new("#{res} is not a valid resource.") unless Object.const_defined?(res)
    
    method = request.request_method.downcase.to_sym
    resource = nil
    
    if id.nil?
      # Reference to Class
      resource = Object.const_get(res)
    else
      # Reference to instance of class
      resource = Object.const_get(res).new(id.to_i)
    end

    return {'data' => resource.public_send(method)}
  })
end

route :get, :post, :put, :patch, :delete, :options, '*' do
  process_request(lambda {
    return {'data' => 'get|post|put|patch|delete /:resource[/:id]'}
  })
end