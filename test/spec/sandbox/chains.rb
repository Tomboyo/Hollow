require 'minitest/autorun'
require_relative '../../../lib/sandbox'

describe Sandbox::Application do

  before do
    @application = Sandbox::Application.new
  end

  it 'Invokes before-chain methods in order before Resource methods' do

    class BeforeChain
      include Sandbox::Resource::Stateless
      include Sandbox::Resource::Chains

      chain :before, :all, -> (request) { request[:test] << 1 }
      chain :before, :get, -> (request) { request[:test] << 3 }
      chain :before, :all, -> (request) { request[:test] << 2 }
      chain :before, :get, -> (request) { request[:test] << 4 }

      def get(request)
        request[:test] << 5
      end
    end

    data = { test: [] }
    @application.handle_request(
      resource: :BeforeChain,
      method:   :get,
      data:     data
    )
    assert_equal [1, 2, 3, 4, 5], data[:test]
  end

  it 'Invokes after-chain methods in order after Resource methods' do
    class AfterChain
      include Sandbox::Resource::Stateless
      include Sandbox::Resource::Chains

      chain :after, :all, -> (request) { request[:test] << 2 }
      chain :after, :get, -> (request) { request[:test] << 4 }
      chain :after, :all, -> (request) { request[:test] << 3 }
      chain :after, :get, -> (request) { request[:test] << 5 }

      def get(request)
        request[:test] << 1
      end
    end

    data = { test: [] }
    @application.handle_request(
      resource: :AfterChain,
      method:   :get,
      data:     data
    )
    assert_equal [1, 2, 3, 4, 5], data[:test]
  end

end
