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
        def get
          5
        end
      end
      assert_equals 5, application.handle_request(:resource => :AResource,
          :method => :get)
    end

    it 'Only forwards request to Resource-extending classes' do

      NOTACLASS = 5
      assert_raises(Sandbox::ResourceException) {
        application.handle_request(:resource => :NOTACLASS, :method => :get)
      }

      module AlsoNotAClass ; end
      assert_raises(Sandbox::ResourceException) {
        application.handle_request(:resource => :AlsoNotAClass, :method => :get)
      }

      class NotAResource ; end
      assert_raises(Sandbox::ResourceException) {
        application.handle_request(:resource => :NotAResource, :method => :get)
      }
    end
  end
end
