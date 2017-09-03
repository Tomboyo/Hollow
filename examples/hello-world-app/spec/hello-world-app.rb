require_relative "../launch.rb"
require 'minitest/autorun'
require 'rack/test'

include Rack::Test::Methods

def app
  Sinatra::Application
end

describe "Example" do
  describe 'HelloWorld Resource' do
    it 'Responds to get with a greeting' do
      get '/HelloWorld'
      assert last_response.ok?
      assert_equal "Hello, world!", last_response.body
    end

    it 'Responds to post with a greeting based on data' do
      post '/HelloWorld', { greeting: "Bonjour" }
      assert last_response.ok?
      assert_equal "Bonjour, world!", last_response.body
    end

    it "Responds to put with a greeting based on data" do
      put '/HelloWorld', { name: "Teal'c" }
      assert last_response.ok?
      assert_equal "Hello, Teal'c!", last_response.body
    end
  end
end
