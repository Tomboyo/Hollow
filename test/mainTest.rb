require_relative 'test_helper'

describe "The base sandbox app" do

  #
  # Reusables
  #

  invalid_resource_proc = proc do |methods, routes|
    methods.each do |method|
      routes.each do |route|
        self.send(method, route)
        last_response.body.must_equal process_request(lambda {
          raise ResourceInvalidError.new()
        })
      end
    end
  end

  response_include_proc = proc do |methods, routes, includables|
    methods.each do |method|
      routes.each do |route|
        self.send(method, route)
        response = JSON.parse(last_response.body)
        includables.any? { |k| response.include? k }.must_equal true
      end
    end
  end

  resource_instance_proc = proc do |methods, resources|
    methods.each do |method|
      resources.each do |resource|
        10.times do
          id = rand(100)
          re = resource.new(id)
          self.send(method, "/#{resource}/#{id}")
          last_response.body.must_equal process_request(lambda {
            return {'data' => re.public_send(method)}
          })
        end
      end
    end
  end

  resource_static_proc = proc do |methods, resources|
    methods.each do |method|
      resources.each do |resource|
        self.send(method, "/#{resource}")
        last_response.body.must_equal process_request(lambda {
          return {'data' => resource.public_send(method)}
        })

        self.send(method, "/#{resource}/")
        last_response.body.must_equal process_request(lambda {
          return {'data' => resource.public_send(method)}
        })
      end
    end
  end

  it 'will respond with regularly-formatted JSON to all requests' do
    # verify one of three keys is set on the response
    response_include_proc.call(
      $settings.resource_methods,
      %w[
        / /NotAResource /NotAResource/ NotAResource/5 StaticAndInstanceAccess
        StaticAndInstanceAccess/ StaticAndInstanceAccess/5
      ],
      %w[data error internal_error]
    )

    # verify the internal_error flag is set when appropriate
    # System warnings from this call are suppressed with the 'true' arguemnts
    process_request(lambda { Object.NOPE }, true).must_include 'internal_error'
  end

  it "will respond with an error message to invalid resource requests" do
    # Not real classes
    response_include_proc.call(
      $settings.resource_methods,
      %w[/NotAResource /NotAResource/ /NotAResource/5],
      %w[error]
    )

    # Not ResourceInterfaces, but real classes
    invalid_resource_proc.call($settings.resource_methods, %w[
      /NoAccess /NoAccess/ /NoAccess/5 /Helper
      /Helper/ /Helper/5
    ])
  end

  it 'will discriminate between instance/static access of resources' do
    # instance only
    invalid_resource_proc.call($settings.resource_methods, %w[
      /InstanceAccessOnly /InstanceAccessOnly/
    ])

    # static only
    invalid_resource_proc.call($settings.resource_methods, %w[
      /StaticAccessOnly/5
    ])
  end

  it "will invoke class methods of valid resources if no ID is provided" do
    resource_static_proc.call(
      $settings.resource_methods,
      [StaticAccessOnly, StaticAndInstanceAccess]
    )
  end

  it "will invoke instance methods of valid resources if an ID is specified" do
    resource_instance_proc.call(
      $settings.resource_methods,
      [InstanceAccessOnly, StaticAndInstanceAccess]
    )
  end
end
