# -*- encoding: utf-8 -*-
require File.expand_path('../lib/zendesk2/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Josh Lane"]
  gem.email         = ["me@joshualane.com"]
  gem.description   = %q{Zendesk V2 API client}
  gem.summary       = %q{Zendesk V2 API client}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "zendesk2"
  gem.require_paths = ["lib"]
  gem.version       = Zendesk2::VERSION

  gem.add_dependency "cistern"
end
