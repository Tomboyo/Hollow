# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "hollow/version"

Gem::Specification.new do |spec|
  spec.name          = "hollow"
  spec.version       = Hollow::VERSION
  spec.authors       = ["Tom Simmons"]
  spec.email         = ["tomasimmons@gmail.com"]

  spec.summary       = "Bridge the gap from routing to Resource."
  spec.description   = %q{
    Hollow is a drop-in component for building RESTful services that bridges
    from any routing solution (like Sinatra) to your back-end. You flesh out
    your service with Resource classes, you pick a Router to forward some
    traffic to Hollow, and it works. GET /HelloWorld becomes HelloWorld.get().
  }
  spec.homepage      = "https://www.github.com/tomboyo/hollow"
  spec.license       = "MIT"

  # Prevent pushing this gem to all but the specified locations.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = 'https://rubygems.org'
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    !f.match(%r{^(lib)/}) &&
    !%w(README.md LICENSE.txt).include?(f)
  end
  spec.require_paths = ["lib"]

  spec.add_dependency "require_all", "~> 1"
  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake",    "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5"
  spec.add_development_dependency "rack-test", "~> 0.7"
end
