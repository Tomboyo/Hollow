require 'hollow'
require 'hollow/sinatra_router_factory'
#require 'sinatra'
#require 'sinatra/multi_route'

Hollow::SinatraRouterFactory::create_router_for(
  Hollow::Application.new(
    autorequire: {
      root: "#{File.dirname __FILE__}", # This directory is the application root
      directories: ['resources']        # Resource types are in ./resouces
    },
    # Only handle these requests; deny all others
    resource_methods: %i(get post put)
  )
).run!
