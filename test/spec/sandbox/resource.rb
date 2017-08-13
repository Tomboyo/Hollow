require 'minitest/autorun'
require_relative '../../../lib/sandbox/application'
require_relative '../../../lib/sandbox/resource/stateless/stateless'
require_relative '../../../lib/sandbox/resource/stateful/stateful'

describe Sandbox::Resource::Stateless do

  class StatelessResource
    include Sandbox::Resource::Stateless
  end

  it 'Only creates a single instance of the Resource' do
    handler = StatelessResource.get_instance
    assert_equal handler, StatelessResource.get_instance
  end

  it 'Is also a Resource' do
    assert StatelessResource.kind_of?(Sandbox::Resource)
  end

  it 'Creates one instance per Resource type' do
    class A ; include Sandbox::Resource::Stateless ; end
    class B ; include Sandbox::Resource::Stateless ; end

    refute_equal A.get_instance, B.get_instance
  end
end

describe Sandbox::Resource::Stateful do
  class StatefulResource
    include Sandbox::Resource::Stateful
  end

  it 'Creates multiple instances of the Resource' do
    refute_equal StatefulResource.get_instance, StatefulResource.get_instance
  end

  it 'Is also a Resource' do
    assert StatefulResource.kind_of?(Sandbox::Resource)
  end
end
