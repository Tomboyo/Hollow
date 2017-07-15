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

  it 'Delegates to Resources' do

    class AResource
      extend Sandbox::Resource
      def self.getHandler ; self.new ; end
      def get(*args) ; 5 ; end
    end

    assert_equal 5, @application.handle_request(:AResource, :get)
  end

  it 'Only delegates to actual Resources' do
    SOME_CONSTANT = 5
    assert_raises(Sandbox::ResourceException) {
      @application.handle_request(:SOME_CONSTANT, :get)
    }

    module SomeModule ; end
    assert_raises(Sandbox::ResourceException) {
      @application.handle_request(:SomeModule, :get)
    }

    class SomeClass ; end
    assert_raises(Sandbox::ResourceException) {
      @application.handle_request(:SomeClass, :get)
    }
  end

  it 'Only invokes configured resource methods' do

    class HelloWorldResource
      extend Sandbox::Resource
      def self.getHandler ; self.new ; end
      def get(*args) ; "Hello!" end
      def post(*args) ; "World!" ; end
    end

    # get and post are fine
    @application.handle_request(:HelloWorldResource, :get)
    @application.handle_request(:HelloWorldResource, :post)

    # patch is not configured!
    assert_raises(Sandbox::ResourceMethodException) do
      @application.handle_request(:HelloWorldResource, :patch)
    end
  end

  it 'Will not invoke undefiend methods' do

    class StumpResource
      extend Sandbox::Resource
      def self.getHandler ; self.new ; end
    end

    assert_raises(Sandbox::ResourceMethodException) do
      @application.handle_request(:StumpResource, :get)
    end
  end

  it 'Will not delegate to resources that do not define getHandler' do

    class StumpResource
      extend Sandbox::Resource
    end

    assert_raises(Sandbox::ResourceException) do
      @application.handle_request(:StumpResource, :get)
    end
  end
end
