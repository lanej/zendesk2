# -*- encoding: utf-8 -*-
require File.expand_path('../lib/zendesk2/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Josh Lane"]
  gem.description   = %q{Zendesk V2 API client}
  gem.email         = ["me@joshualane.com"]
  gem.homepage      = "http://joshualane.com/zendesk2"
  gem.license       = "MIT"
  gem.summary       = %q{Zendesk V2 API client}

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "zendesk2"
  gem.require_paths = ["lib"]
  gem.version       = Zendesk2::VERSION

  gem.add_dependency "addressable", "~> 2.2"
  gem.add_dependency "cistern", "~> 0.6"
  gem.add_dependency "faraday", "~> 0.9"
  gem.add_dependency "faraday_middleware"
  gem.add_dependency "jwt", "~> 0.1"
end
