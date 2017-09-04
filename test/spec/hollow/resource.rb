require 'minitest/autorun'
require 'singleton'
require_relative '../../../lib/hollow'

describe Hollow::Resource::Stateless do

  class StatelessResource
    extend Hollow::Resource::Stateless
  end

  it 'Is a Resource' do
    assert StatelessResource.kind_of? Hollow::Resource
  end

  it 'Is a Singleton' do
    assert StatelessResource.instance.is_a? Singleton
  end
end

describe Hollow::Resource::Stateful do
  class StatefulResource
    extend Hollow::Resource::Stateful
  end

  it 'Creates multiple instances of the Resource' do
    refute_equal StatefulResource.instance, StatefulResource.instance
  end

  it 'Is a Resource' do
    assert StatefulResource.kind_of? Hollow::Resource
  end
end

describe Hollow::Resource do
  class Resource
    extend Hollow::Resource
  end

  it 'Defines include, which must be overwritten' do
    assert_raises(StandardError) do
      Resource::instance
    end
  end
end
