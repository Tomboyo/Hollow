require 'minitest/autorun'
require_relative '../../../lib/hollow'

describe Hollow::Resource::Stateless do

  class StatelessResource
    include Hollow::Resource::Stateless
  end

  it 'Only creates a single instance of the Resource' do
    handler = StatelessResource.get_instance
    assert_equal handler, StatelessResource.get_instance
  end

  it 'Is also a Resource' do
    assert StatelessResource.kind_of?(Hollow::Resource)
  end

  it 'Creates one instance per Resource type' do
    class A ; include Hollow::Resource::Stateless ; end
    class B ; include Hollow::Resource::Stateless ; end

    refute_equal A.get_instance, B.get_instance
  end
end

describe Hollow::Resource::Stateful do
  class StatefulResource
    include Hollow::Resource::Stateful
  end

  it 'Creates multiple instances of the Resource' do
    refute_equal StatefulResource.get_instance, StatefulResource.get_instance
  end

  it 'Is also a Resource' do
    assert StatefulResource.kind_of?(Hollow::Resource)
  end
end
