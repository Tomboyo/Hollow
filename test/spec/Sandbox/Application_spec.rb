require 'minitest/autorun'
require_relative '../../../lib/Sandbox/Application'

describe Sandbox::Application do

  class TestResource
    include Sandbox::Resource::Stateless

    def get(request) ; request ; end
    def post(request) ; request ; end

    def some_method(*args) ; args ; end
  end

  before do
    @application = Sandbox::Application.new
  end

  it 'Delegates to Resources' do
    assert_equal "Hello World!", @application.handle_request(
        :TestResource, :get, "Hello World!")
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
    # get and post are fine
    @application.handle_request(:TestResource, :get)
    @application.handle_request(:TestResource, :post)

    # some_method is defined by TestResource, but is not configured in
    # the application as an available Resource method
    assert_raises(Sandbox::ResourceMethodException) do
      @application.handle_request(:TestResource, :some_method)
    end
  end

  it 'Can be configured to accept specific resource methods' do
    application = Sandbox::Application.new({
      resource_methods: ["foo"]
    })

    class FooResource
      include Sandbox::Resource::Stateless
      def foo(request) ; :bar ; end
    end

    assert_equal :bar, application.handle_request(:FooResource, :foo)
  end

  it 'Will not invoke undefiend methods' do
    assert_raises(Sandbox::ResourceMethodException) do
      @application.handle_request(:TestResource, :garbanzo_beans)
    end
  end

  it 'Delivers arguments to the resource' do
    args = { a: "A!" }
    assert_equal args, @application.handle_request(
        :TestResource, :get, args)
  end

  it 'Will load classes from autorequire directories' do
    # Load resources from test/resource/a
    application = Sandbox::Application.new({
      autorequire: {
        root: "#{File.dirname __FILE__}/../../resource",
        directories: [ 'a' ]
      }
    })

    # A and B resources are autoloaded and available for get()ting
    assert_equal "A", application.handle_request(:AResource, :get)
    assert_equal "B", application.handle_request(:BResource, :get)
  end
end
