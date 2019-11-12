# -*- encoding: utf-8 -*-
# frozen_string_literal: true
require File.expand_path('../lib/zendesk2/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['Josh Lane']
  gem.description   = 'Zendesk V2 API client'
  gem.email         = ['me@joshualane.com']
  gem.homepage      = 'http://joshualane.com/zendesk2'
  gem.license       = 'MIT'
  gem.summary       = 'Zendesk V2 API client'

  gem.files         = `git ls-files`.split($OUTPUT_RECORD_SEPARATOR)
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = 'zendesk2'
  gem.require_paths = ['lib']
  gem.version       = Zendesk2::VERSION

  gem.required_ruby_version = '~> 2.0'

  gem.add_dependency 'cistern',            '~> 2.3'
  gem.add_dependency 'faraday',            '~> 0.9'
  gem.add_dependency 'faraday_middleware', '~> 0.9'
  gem.add_dependency 'jwt',                '>= 1.0', '< 3.0'
  gem.add_dependency 'json',               '> 1.7', '< 3.0'
end
