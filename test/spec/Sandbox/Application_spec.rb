require 'minitest/autorun'
require_relative '../../../lib/Sandbox/Application'

describe Sandbox::Application do

  application = Sandbox::Application.new({
    # Do not require any resources outside this spec
    :autorequire => {
      :directories => []
    }
  })

  describe 'handle_request' do
    it 'Will forward requests to Resource-extending classes' do

      class AResource
        extend Sandbox::Resource
        def self.getHandler ; AResource.new ; end
        def get(*args) ; 5 ; end
      end

      assert_equal 5, application.handle_request(:AResource, :get)
    end

    it 'Will not forward to non-Resource Objects' do
      SOME_CONSTANT = 5
      assert_raises(Sandbox::ResourceException) {
        application.handle_request(:SOME_CONSTANT, :get)
      }

      module SomeModule ; end
      assert_raises(Sandbox::ResourceException) {
        application.handle_request(:SomeModule, :get)
      }

      class SomeClass ; end
      assert_raises(Sandbox::ResourceException) {
        application.handle_request(:SomeClass, :get)
      }

      some_instance = SomeClass.new
      assert_raises(Sandbox::ResourceException) {
        application.handle_request(:some_instance, :get)
      }
    end
  end
end
