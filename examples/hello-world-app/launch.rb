require 'sandbox'
require 'sandbox/sinatra_router_factory'
require 'sinatra'
require 'sinatra/multi_route'

router = Sandbox::SinatraRouterFactory::create_router_for(
  Sandbox::Application.new(
    autorequire: {
      root: "#{File.dirname __FILE__}", # This directory is the application root
      directories: ['resources']        # Resource types are in ./resouces
    },
    # Only handle these requests; deny all others
    resource_methods: %i(get post put)
  )).run!
