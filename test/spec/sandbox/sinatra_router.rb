require 'minitest/autorun'
require 'rack/test'
require_relative '../../../lib/sandbox'
require_relative '../../../lib/sandbox/sinatra_router'

include Rack::Test::Methods

ENV['RACK_ENV'] = 'test'

def app
  Sandbox::SinatraRouterFactory::create_router_for(Sandbox::Application.new)
end

describe Sandbox::SinatraRouterFactory do

  describe 'create_router_for' do
    it 'Creates a new class which extends Sinatra::Base' do
      type = Sandbox::SinatraRouterFactory::create_router_for(
          Sandbox::Application.new)
      assert type.kind_of?(Sinatra::Base.class)
    end

    it 'Creates a class that routes to a Sandbox::Application' do
      class TestResource
        include Sandbox::Resource::Stateless
        def get(data) ;  "true" ; end
        def post(data) ; "true" ; end
      end

      get '/TestResource'
      assert_equal "true", last_response.body

      post '/TestResource'
      assert_equal "true", last_response.body

      put '/TestResource'
      refute_equal "true", last_response.body
    end
  end
end
