# Verify that the test case resources being used do not all just raise errors,
# which would skew the results of mainTest.rb
require_relative '../test_helper'

# NoAccess is not a resource but has methods that resemble resources.
# NoAccess is used to verify that Sandbox will not permit access to methods of
#   non-resources.
describe NoAccess do
  it 'does not implement (extend) ResourceInterface' do
    NoAccess.is_a?(ResourceInterface).must_equal false
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

# Access is a proper resource that Sandbox should use to service requests.
describe Access do
  it 'implements (extends) ResourceInterface' do
    Access.is_a?(ResourceInterface).must_equal true
  end

  it 'responds only to ::get and .get' do
    Access.singleton_methods(false).must_include :get
    Access.instance_methods(false).must_include :get
    Access.singleton_methods(false).length.must_equal 1
    Access.instance_methods(false).length.must_equal 1
  end

  it 'returns a String on ::get' do
    Access::get.must_be_kind_of String
  end

  it 'returns an Int on .get' do
    Access.new.get.must_be_kind_of Integer
  end
end
