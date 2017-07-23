require 'minitest/autorun'
require_relative '../../../lib/Sandbox/Application'

describe Sandbox::Application do

  before do
    @application = Sandbox::Application.new
  end

  it 'Invokes before-chain methods in order before Resource methods' do

    class BeforeChain
      include Sandbox::Resource::Stateless
      include Sandbox::Resource::BeforeChain

      @@before_chain = {
        all: [ -> (request) { request[:test] << 1 }],
        get: [ -> (request) { request[:test] << 2 }]
      }

      def get(request)
        request[:test] << 3
      end
    end

    request = { test: [] }
    @application.handle_request(:BeforeChain, :get, request)

    assert_equal [1, 2, 3], request[:test]
  end

end
