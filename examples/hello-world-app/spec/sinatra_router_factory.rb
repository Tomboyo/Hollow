require 'minitest/autorun'
require 'rack/test'
require 'hollow'
require_relative '../lib/sinatra_router_factory'

include Rack::Test::Methods

ENV['RACK_ENV'] = 'test'

# A Rack::Test hook. The application class returned will be the target for test
# methods like get, post, put, patch.
def app
  SinatraRouterFactory::create_router_for(Hollow::Application.new)
end

describe SinatraRouterFactory do

  describe 'create_router_for' do
    it 'Creates a new class which extends Sinatra::Base' do
      type = SinatraRouterFactory::create_router_for(
          Hollow::Application.new)
      assert type.kind_of?(Sinatra::Base.class)
    end

    it 'Creates a class that routes to a Hollow::Application' do
      # The router is using default settings and as such will listen for get
      # put, post, and more.
      class TestResource
        include Hollow::Resource::Stateless
        def get(data)  ; "response" ; end
        def post(data) ; "response" ; end
        # No Put!
      end

      get '/TestResource'
      assert last_response.ok?
      assert_equal "response", last_response.body

      post '/TestResource'
      assert last_response.ok?
      assert_equal "response", last_response.body

      put '/TestResource'
      assert last_response.ok?
      refute_equal "response", last_response.body
    end
  end
end
