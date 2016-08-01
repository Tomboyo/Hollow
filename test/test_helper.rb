ENV['RACK_ENV'] = 'test'

require_relative '../Sandbox'
require 'minitest/autorun'
require 'rack/test'

include Rack::Test::Methods
include Helper

def app
  Sandbox
end

class RequestGenerator
  # Makes standardized requests to resources and/or requests to specific routes
  # String[] routes, resources
  # RID holds a collection of ID fields that may be passed to resources.
  #   Including false in this array will send an id-less request, as well.
  # Mapping holds a hash of expected return values for certain requests.
  #   mapping['resource' || 'route' || '*']['method' || '*'] => expected
  #   expected may be an array of values, each of which will be tested
  #   individually and passed to the block as "expected". If there is more than
  #   one expected value for a request, each will be tested individually in
  #   turn.
  # The block responding to resources will receive the resource, rid, and method
  #   to allow for granular test cases.
  def self.make_requests(routes: [], resources: [], mapping: {}, rid: [])
    $settings.resource_methods.each do |method|
      resources.each do |resource|
        expected = [
          mapping.dig(resource),
          mapping.dig('*')
        ].compact.map do |k|
          temp = []
          temp << k['*'] if k.dig('*')
          temp << k[method] if k.dig(method)
          next if temp.empty?
          temp
        end.flatten
        expected = [nil] if expected.empty?

        rid.each do |id|
          case id
          when rid.nil?
            expected.each do |v|
              self.send(method, "/#{resource}")
              yield last_response.body, v
              self.send(method, "/#{resource}/")
              yield last_response.body, v
            end
          else
            self.send(method, "/#{resource}/#{id}")
            expected.each do |v|
              yield last_response.body, v, resource, id, method
            end
          end
        end
      end

      routes.each do |route|
        expected = []
        expected << mapping['*'] if !mapping.dig('*').nil?
        expected << mapping[route] if !mapping.dig(route).nil?
        expected.flatten!
        expected = [nil] if expected.empty?

        self.send(method, route)
        expected.each { |v| yield last_response.body, v }
      end
    end
  end
end
