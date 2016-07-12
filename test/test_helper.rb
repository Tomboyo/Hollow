ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'rack/test'
require_relative '../Sandbox'

include Rack::Test::Methods
include Helper

def app
  Sandbox
end

class RequestGenerator
  # Makes static requests to each indicated resource and passes the response to
  # a block along with the expected value assigned to the Resoure.request call.
  # resources: array of resources to test
  # mapping: hash of resources -> HTTP methods -> expected values of requests
  #   mapping[resource][method] is given to the block as the expected value of
  #   the request.
  # block: The block is given the response body and the value extracted from the
  #   mapping.
  def self.make_static_resource_requests(resources, mapping)
    resources.each do |resource|
      $settings.resource_methods.each do |method|
        expected = mapping.dig(resource, method)

        self.send(method, "/#{resource}")
        yield last_response.body, expected

        self.send(method, "/#{resource}/")
        yield last_response.body, expected
      end
    end
  end

  def self.make_instance_resource_requests(resources, rid, mapping)
    resources.each do |resource|
      $settings.resource_methods.each do |method|
        expected = mapping.dig(resource, method)

        rid.each do |id|
          self.send(method, "/#{resource}/#{id}")
          yield last_response.body, expected, resource, id, method
        end
      end
    end
  end

  def self.make_generic_requests(routes, mapping)
    routes.each do |route|
      $settings.resource_methods.each do |method|
        self.send(method, route)
        yield last_response.body, (mapping.dig(route, method) ||
          mapping.dig(route))
      end
    end
  end
end
