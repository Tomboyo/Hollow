require_relative 'test_helper'

describe "The base sandbox app" do

  it 'will respond with regularly-formatted JSON to all requests' do
    # verify expected requests set data or error keys
    RequestGenerator.make_generic_requests(
      %w[
        / /NotAResource /NotAResource/ NotAResource/5 StaticAndInstanceAccess
        StaticAndInstanceAccess/ StaticAndInstanceAccess/5
      ], {}
    ) do |body, expected|
      body = JSON.parse(body)
      %w[data error].any? { |key| body.include? key}.
        must_equal true
    end

    # verify the internal_error flag is set when appropriate
    # System warnings from this call are suppressed with the 'true' arguemnt
    process_request(lambda { Object.NOPE }, true).must_include 'internal_error'
  end

  it "will respond with an error message to invalid resource requests" do
    # Not real classes
    RequestGenerator.make_static_resource_requests(
      ['NotAResource'], {}
    ) do |body|
      JSON.parse(body).must_include 'error'
    end

    RequestGenerator.make_instance_resource_requests(
      ['NotAResource'], 1..10, {}
    ) do |body|
      JSON.parse(body).must_include 'error'
    end

    # Not ResourceInterfaces, but real classes
    RequestGenerator.make_static_resource_requests(
      [NoAccess, Helper], {}
    ) do |body|
      JSON.parse(body).must_include 'error'
    end

    RequestGenerator.make_instance_resource_requests(
      [NoAccess, Helper], 1..10, {}
    ) do |body|
      JSON.parse(body).must_include 'error'
    end
  end

  it 'will discriminate between instance/static access of resources' do
    # instance only
    RequestGenerator.make_static_resource_requests(
      [InstanceAccessOnly], {}
    ) do |body, expected|
      JSON.parse(body).must_include 'error'
    end

    # static only
    RequestGenerator.make_instance_resource_requests(
      [StaticAccessOnly], [1..10], {}
    ) do |body, expected|
      JSON.parse(body).must_include 'error'
    end
  end

  it "will invoke class methods of valid resources if no ID is provided" do
    RequestGenerator.make_static_resource_requests(
      [StaticAccessOnly, StaticAndInstanceAccess],
      {
        StaticAccessOnly => {get: 'data'},
        StaticAndInstanceAccess => {get: 'data'}
      }
    ) do |body, expected|
      JSON.parse(body).must_include String.try_convert(expected) || 'error'
    end
  end

  it "will invoke instance methods of valid resources if an ID is specified" do
    # These requests should receive data payloads
    RequestGenerator.make_instance_resource_requests(
      [InstanceAccessOnly, StaticAndInstanceAccess],
      1..10,
      {
        InstanceAccessOnly => {get: 'data'},
        StaticAndInstanceAccess => {get: 'data'}
      }
    ) do |body, expected, resource, id, method|
      body = JSON.parse(body)
      if expected.nil?
        body.must_include 'error'
      else
        body.must_include expected
        resource = resource.new(id)
        body[expected].must_equal resource.send(method)
      end
    end
  end
end
