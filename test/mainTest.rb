ENV['RACK_ENV'] = 'test'
require 'minitest/autorun'
require 'rack/test'
require_relative '../lib/Helper'
require File.expand_path('../../main.rb', __FILE__)
require File.expand_path('../../resource/ResourceExample.rb', __FILE__)

include Rack::Test::Methods
include Helper

def app
  Sinatra::Application
end

methods = [:get, :post, :put, :patch, :delete, :options]
resources = [ResourceExample]

describe "The base sandbox app" do
  it 'will respond with regularly-formatted JSON to all requests' do
    methods.each do |method|
      self.send(method, '/')
      response = JSON.parse(last_response.body)
      (response.include?('error') || response.include?('data')).must_equal true
      
      # The following are invalid requests
      self.send(method, '/NotAResource')
      response = JSON.parse(last_response.body)
      (response.include?('error') || response.include?('data')).must_equal true
      
      self.send(method, '/NotAResource/')
      response = JSON.parse(last_response.body)
      (response.include?('error') || response.include?('data')).must_equal true
      
      self.send(method, '/NotAResource/5')
      response = JSON.parse(last_response.body)
      (response.include?('error') || response.include?('data')).must_equal true
              
      # The following are valid requests
      self.send(method, '/ResourceExample')
      response = JSON.parse(last_response.body)
      (response.include?('error') || response.include?('data')).must_equal true
        
      self.send(method, '/ResourceExample/')
      response = JSON.parse(last_response.body)
      (response.include?('error') || response.include?('data')).must_equal true
        
      self.send(method, '/ResourceExample/1')
      response = JSON.parse(last_response.body)
      (response.include?('error') || response.include?('data')).must_equal true


      # Add other routes as necessary
    end
  end
  
  it "will respond with an error message when a requested resource is invalid" do    
    methods.each do |method|
      self.send(method, '/NotAResource')
      response = JSON.parse(last_response.body)
      response.must_include 'error'
      
      self.send(method, '/NotAResource/')
      response = JSON.parse(last_response.body)
      response.must_include 'error'
        
      self.send(method, '/NotAResource/1')
      response = JSON.parse(last_response.body)
      response.must_include 'error'
    end
  end
  
  it "will invoke class methods of valid resources if no ID is provided" do
    methods.each do |method|
      resources.each do |resource|
        self.send(method, "/#{resource}")
        response = last_response.body
        response.must_equal process_request(lambda {
          return {'data' => resource.public_send(method)}
        })
        
        self.send(method, "/#{resource}/")
        response = last_response.body
        response.must_equal process_request(lambda {
          return {'data' => resource.public_send(method)}
        })
      end
    end
  end
  
  it "will invoke instance methods of valid resources if an ID is specified" do
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
end