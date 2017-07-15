require 'minitest/autorun'
require_relative '../../../lib/Sandbox/Application'

describe Sandbox::Application do

  before do
    @application = Sandbox::Application.new({
      # Do not require any resources outside this spec
      :autorequire => {
        :directories => []
      }
    })
  end

  it 'Delegates to Resources' do

    class AResource
      extend Sandbox::Resource
      def self.getHandler ; AResource.new ; end
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
end
