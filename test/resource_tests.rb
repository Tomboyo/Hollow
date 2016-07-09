# Verify that the test case resources being used do not all just raise errors,
# which would skew the results of mainTest.rb
require_relative 'test_helper'

describe InstanceAccessOnly do
  it 'implements ResourceInterface non-statically only' do
    InstanceAccessOnly.is_a?(ResourceInterface).must_equal false
    InstanceAccessOnly.include?(ResourceInterface).must_equal true
  end

  it 'responds only to .get' do
    InstanceAccessOnly.instance_methods(false).must_include :get
    (InstanceAccessOnly.instance_methods(false) +
      InstanceAccessOnly.singleton_methods(false)).length.must_equal 1
  end

  it 'returns its id on .get' do
    10.times do
      n = rand(100)
      r = InstanceAccessOnly.new(n)
      r.get.must_equal n
    end
  end
end

describe NoAccess do
  no_access = NoAccess.new

  it 'does not implement ResourceInterface' do
    NoAccess.is_a?(ResourceInterface).must_equal false
    NoAccess.include?(ResourceInterface).must_equal false
  end

  it 'responds only to ::get and .get calls' do
    NoAccess.instance_methods.must_include :get
    NoAccess.singleton_methods.must_include :get
    (NoAccess.instance_methods(false) + NoAccess.singleton_methods(false)).
      length.must_equal 2
  end

  it 'returns a String on ::get and .get' do
    NoAccess.get.must_be_kind_of String
    NoAccess.new.get.must_be_kind_of String
  end
end

describe StaticAccessOnly do
  it 'implements ResourceInterface non-statically' do
    StaticAccessOnly.is_a?(ResourceInterface).must_equal true
    StaticAccessOnly.include?(ResourceInterface).must_equal false
  end

  it 'responds only to ::get' do
    StaticAccessOnly.singleton_methods(false).must_include :get
    (StaticAccessOnly.instance_methods(false) +
      StaticAccessOnly.singleton_methods(false)).length.must_equal 1
  end

  it 'returns a String on ::get' do
    StaticAccessOnly.get.must_be_kind_of String
  end
end

describe StaticAndInstanceAccess do
  it 'implements ResourceInterface statically and non-statically' do
    StaticAndInstanceAccess.is_a?(ResourceInterface).must_equal true
    StaticAndInstanceAccess.include?(ResourceInterface).must_equal true
  end

  it 'responds only to :get and .get' do
    StaticAndInstanceAccess.instance_methods(false).must_include :get
    StaticAndInstanceAccess.singleton_methods(false).must_include :get
    (StaticAndInstanceAccess.instance_methods(false) +
      StaticAndInstanceAccess.singleton_methods(false)).length.must_equal 2
  end

  it 'returns its id on .get' do
    10.times do
      n = rand(100)
      r = StaticAndInstanceAccess.new(n)
      r.get.must_equal n
    end
  end
end
