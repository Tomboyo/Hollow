require 'minitest/autorun'
require_relative '../../../lib/hollow'

describe Hollow::Application do

  class TestResource
    include Hollow::Resource::Stateless

    def get(request) ; request ; end
    def post(request) ; request ; end

    def some_method(*args) ; args ; end
  end

  before do
    @application = Hollow::Application.new
  end

  it 'Delegates to Resources' do
    assert_equal({}, @application.handle_request(
      resource: :TestResource,
      method:   :get,
      data:     {}
    ))
  end

  it 'Does not require a data payload' do
    assert_equal({}, @application.handle_request(
      resource: :TestResource,
      method:   :get
    ))
  end

  it 'Only delegates to actual Resources' do
    SOME_CONSTANT = 5
    assert_raises(Hollow::Application::ResourceException) do
      @application.handle_request(
        resource: :SOME_CONSTANT,
        method:   :get
      )
    end

    module SomeModule ; end
    assert_raises(Hollow::Application::ResourceException) do
      @application.handle_request(
        resource: :SomeModule,
        method:   :get
      )
    end

    class SomeClass ; end
    assert_raises(Hollow::Application::ResourceException) do
      @application.handle_request(
        resource: :SomeClass,
        method:   :get
      )
    end
  end

  it 'Only invokes configured resource methods' do
    # get and post are fine
    @application.handle_request(resource: :TestResource, method: :get)
    @application.handle_request(resource: :TestResource, method: :post)

    # some_method is defined by TestResource, but is not configured in
    # the application as an available Resource method
    assert_raises(Hollow::Application::ResourceMethodException) do
      @application.handle_request(
        resource: :TestResource,
        method:   :some_method
      )
    end
  end

  it 'Can be configured to accept specific resource methods' do
    application = Hollow::Application.new({
      resource_methods: ["foo"]
    })

    class FooResource
      include Hollow::Resource::Stateless
      def foo(request) ; :bar ; end
    end

    assert_equal :bar, application.handle_request(
      resource: :FooResource,
      method: :foo
    )
  end

  it 'Will not invoke undefiend methods' do
    assert_raises(Hollow::Application::ResourceMethodException) do
      @application.handle_request(
        resource: :TestResource,
        method:   :garbanzo_beans
      )
    end
  end

  it 'Delivers data to the resource' do
    data = { a: "a" }
    assert_equal data, @application.handle_request(
        resource: :TestResource,
        method:   :get,
        data:     data
    )
  end

  it 'Will load classes from autorequire directories' do
    # Load resources from test/resource/a
    application = Hollow::Application.new({
      autorequire: {
        root: "#{File.dirname __FILE__}/../../resource",
        directories: [ 'a' ]
      }
    })

    # A and B resources are autoloaded and available for get()ting
    assert_equal "A", application.handle_request(
      resource: :AResource,
      method:   :get
    )

    assert_equal "B", application.handle_request(
      resource: :BResource,
      method:   :get
    )
  end

  it 'Raises informative exceptions' do
    exception = assert_raises(Hollow::Application::ResourceException) do
      @application.handle_request(
        resource: :NotAResource,
        method:   :not_a_method
      )
    end
    assert_includes(exception.message, "NotAResource")
    assert_equal(exception.resource_name, :NotAResource)

    exception = assert_raises(Hollow::Application::ResourceMethodException) do
      @application.handle_request(
        resource: :TestResource,
        method:   :not_a_method
      )
    end

    assert_includes(exception.message, "TestResource")
    assert_includes(exception.message, "not_a_method")
    assert_equal(exception.resource_name, :TestResource)
    assert_equal(exception.method_name, :not_a_method)
  end
end
