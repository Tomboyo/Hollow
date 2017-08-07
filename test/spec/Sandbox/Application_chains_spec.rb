require 'minitest/autorun'
require_relative '../../../lib/Sandbox/Application'

describe Sandbox::Application do

  before do
    @application = Sandbox::Application.new
  end

  it 'Invokes before-chain methods in order before Resource methods' do

    class BeforeChain
      include Sandbox::Resource::Stateless
      include Sandbox::Resource::Chains

      chain_before :all, -> (request) { request[:test] << 1 }
      chain_before :get, -> (request) { request[:test] << 3 }
      chain_before :all, -> (request) { request[:test] << 2 }
      chain_before :get, -> (request) { request[:test] << 4 }

      def get(request)
        request[:test] << 5
      end
    end

    request = { test: [] }
    @application.handle_request(:BeforeChain, :get, request)

    assert_equal [1, 2, 3, 4, 5], request[:test]
  end

  it 'Invokes after-chain methods in order after Resource methods' do
    class AfterChain
      include Sandbox::Resource::Stateless
      include Sandbox::Resource::Chains

      chain_after :all, -> (request) { request[:test] << 2 }
      chain_after :get, -> (request) { request[:test] << 4 }
      chain_after :all, -> (request) { request[:test] << 3 }
      chain_after :get, -> (request) { request[:test] << 5 }

      def get(request)
        request[:test] << 1
      end
    end

    request = { test: [] }
    @application.handle_request(:AfterChain, :get, request)

    assert_equal [1, 2, 3, 4, 5], request[:test]
  end

end
