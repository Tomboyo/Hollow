# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "hollow/version"

Gem::Specification.new do |spec|
  spec.name          = "hollow"
  spec.version       = Hollow::VERSION
  spec.authors       = ["Tom Simmons"]
  spec.email         = ["tomasimmons@gmail.com"]

  spec.summary       = "RESTful plugin for request handling"
  spec.description   = %q{
    Hollow is not a framework--it is a drop-in component used for creating
    RESTful services. You forward requests to Hollow from your routing solution
    (Sinatra?); Hollow then autoloads an appropriate class if necessary to
    handle the request. Additional tools are provided as well, such as filters
    to invoke before and after a resource handles a request ("request chains").
  }
  spec.homepage      = "https://www.github.com/tomboyo/hollow"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features|examples)/})
  end
  spec.require_paths = ["lib"]

  spec.add_dependency "require_all", "~> 1"
  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake",    "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5"
  spec.add_development_dependency "rack-test", "~> 0.7"
end
