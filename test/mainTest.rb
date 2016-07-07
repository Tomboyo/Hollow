ENV['RACK_ENV'] = 'test'
require 'minitest/autorun'
require 'rack/test'
require_relative '../lib/Helper'
require_relative '../main'
require_relative '../resource/ResourceExample'
require_relative '../resource/HiddenResourceExample'
require_relative '../resource/InstanceResourceExample'
require_relative '../resource/StaticResourceExample'

include Rack::Test::Methods
include Helper

def app
  Sinatra::Application
end

methods = [:get, :post, :put, :patch, :delete, :options]
resources = [ResourceExample]

# Note that all process_request calls default to debug=false, which changes
# output for internal errors.

describe "The base sandbox app" do

  #
  # Reusable test procs
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

  response_include_proc = proc do |methods, routes, includables|
    methods.each do |method|
      routes.each do |route|
        self.send(method, route)
        response = JSON.parse(last_response.body)
        includables.any? { |k| response.include? k }.must_equal true
      end
    end
  end

  it 'will respond with regularly-formatted JSON to all requests' do
    # verify one of three keys is set on the response
    response_include_proc.call(
      methods,
      %w[
        / /NotAResource /NotAResource/ NotAResource/5 /ResourceExample
        ResourceExample/ ResourceExample/5
      ],
      %w[data error internal_error]
    )

    # verify the internal_error flag is set when appropriate
    process_request(lambda { Object.NOPE }).must_include 'internal_error'
  end

  it "will respond with an error message to invalid resource requests" do
    response_include_proc.call(
      methods,
      %w[/NotAResource /NotAResource/ /NotAResource/5],
      %w[error]
    )
  end

  it 'will deny requests to non-ResourceInterfaces' do
    # Note that these are real classes being requested!
    invalid_resource_proc.call(methods, %w[
      /Autoloader /Autoloader/ /Autoloader/5 /HiddenResourceExample
      /HiddenResourceExample/ /HiddenResourceExample/5
    ])
  end

  it 'will discriminate between instance/static access of resources' do
    # instance only
    invalid_resource_proc.call(methods, %w[
      /InstanceResourceExample /InstanceResourceExample/
    ])

    # static only
    invalid_resource_proc.call(methods, %w[/StaticResourceExample/5])
  end

  it "will invoke class methods of valid resources if no ID is provided" do
    resource_static_proc.call(methods, [StaticResourceExample, ResourceExample])
  end

  it "will invoke instance methods of valid resources if an ID is specified" do
    resource_instance_proc.call(methods, [InstanceResourceExample, ResourceExample])
  end
end
