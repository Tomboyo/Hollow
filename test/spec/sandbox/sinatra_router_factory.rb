require 'minitest/autorun'
require 'rack/test'
require_relative '../../../lib/sandbox'
require_relative '../../../lib/sandbox/sinatra_router_factory'

include Rack::Test::Methods

ENV['RACK_ENV'] = 'test'

# A Rack::Test hook. The application class returned will be the target for test
# methods like get, post, put, patch.
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
      # The router is using default settings and as such will listen for get
      # put, post, and more.
      class TestResource
        include Sandbox::Resource::Stateless
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
