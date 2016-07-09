ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'rack/test'
require_relative '../Sandbox'

include Rack::Test::Methods
include Helper

def app
  Sandbox
end
