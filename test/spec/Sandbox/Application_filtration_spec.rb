require 'minitest/autorun'
require_relative '../../../lib/Sandbox/Application'

describe Sandbox::Application do

  before do
    @application = Sandbox::Application.new({
      # Do not require any resources outside this spec
      autorequire: {
        directories: []
      },

      # Only delegate get and post requests to Resources
      resource_methods: [:get, :post]
    })
  end

  # A resource skeleton that we can modify per test
  class ChainFilterResource
    extend Sandbox::Resource
    extend Sandbox::Resource::BeforeChain

    @@handler = self.new

    attr_accessor :before_chain
    attr_accessor :doget

    def self.getHandler ; @@handler ; end
    def get(request) ; @doget.call(request) ; end
  end

  # A filter defined by a lambda
  class LamdaChainFilter
    def initialize(filter)
      @filter = filter
    end

    def filter(request = {})
      @filter.call(request)
    end
  end

  class FilterException < StandardError ; end

  it 'Invokes the Resource before-chain prior to request methods' do

    get_called = false
    handler = ChainFilterResource.getHandler
    handler.before_chain = [ LamdaChainFilter.new(lambda { fail }) ]
    handler.doget = lambda { |request| get_called = true }

    assert_raises(FilterException) do
      @application.handle_request(:ChainFilterResource, :get)
    end
    assert_equal false, get_called
  end

end
