require_relative '../test_helper'

describe "The base sandbox app" do

  it 'will respond with regularly-formatted JSON to all requests' do
    # verify expected requests set data or error keys
    RequestGenerator.make_requests({
      routes: %w[ / ],
      resources: %w[ NotAResource, NoAccess, Access ],
      rid: [*1..10] << false
    }) do |body, expected|
      body = JSON.parse(body)
      %w[data error].any? { |key| body.include? key }.must_equal true
    end

    # verify the internal_error flag is set when appropriate
    # System warnings from this call are suppressed with the 'true' arguemnt
    process_request(lambda { Object.NOPE }, true).must_include 'internal_error'
  end

  it 'will not service invalid resource requests' do
    # Includes: improper case, undefined classes, or non-resource classes
    RequestGenerator.make_requests({
      resources: %w[ ACCESS, NotAClass, NoAccess ],
      rid: [*1..10] << false
    }) do |body|
      JSON.parse(body).must_include 'error'
    end
  end

  it 'will service valid resource requests' do
    RequestGenerator.make_requests({
      resources: %w[ Access ],
      rid: [*1..10] << false,
      mapping: { 'Access' => { get: 'data' } }
    }) do |body, expected, resource, id, method|
      JSON.parse(body).must_include expected || 'error'
    end
  end
end
