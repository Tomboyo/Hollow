ENV['RACK_ENV'] = 'production'

require_relative 'Sandbox'

Sandbox.run!
