require 'sinatra/base'
require 'sinatra/multi_route'
require 'json'

require_relative('lib/Autoloader')

class SandboxApp < Sinatra::Base
  register Sinatra::MultiRoute
  
  def initialize(debug=false)
    @debug = debug
    
    @autoloader = Autoloader.new(File::expand_path('..', __FILE__))
    @autoloader.require_files_in('lib')
    @autoloader.require_files_in('resource')
  end
  
  def self.process_request(f)
    return JSON.generate(f.call())
  rescue ResourceMethodUndefinedError => error
    return JSON.generate({'error' => 'The resource you requested can not respond to this request (see OPTIONS)'})
  rescue ApplicationError => error
    return JSON.generate({'error' => error.message})
  rescue => error
    return JSON.generate({'error' => "An internal error occurred. #{@debug ? error.message : ''}"})
  end
  
  # Requests to Resource classes
  route :get, :post, :put, :patch, :delete, :options, '/:resource/?:id?' do |res, id|
    SandboxApp::process_request(lambda {
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
  
      #$DATA = request.env['rack.request.query_hash'] || JSON.parse(request.body.read)
      return {'data' => resource.public_send(method)}
    })
  end
  
  route :get, :post, :put, :patch, :delete, '/' do
    SandboxApp::process_request(lambda {
      return {'data' => 'Use OPTIONS for usage instructions.'}
    })
  end
  
  #TODO: describe API documentation in detail here
  options '*' do
    SandboxApp::process_request(lambda {
      return {'data' => 'get|post|put|patch|delete /:resource[/:id]'}
    })
  end
  
  # Start the app
  run! if __FILE__ == $0
end