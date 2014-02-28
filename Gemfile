source 'https://rubygems.org'

# Specify your gem's dependencies in zendesk2.gemspec
gemspec

gem 'rake'
 # To avoid warnings from JWT
gem 'json', '~> 1.7.7'

group :development, :test do
  gem 'pry-nav'
end

group :test do
  gem 'awesome_print'
  gem 'guard-bundler', require: false
  gem 'guard-rspec', require: false
  gem 'rspec'
end
