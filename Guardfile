# frozen_string_literal: true
guard 'bundler' do
  watch('Gemfile')
  watch(/^.+\.gemspec/)
end

guard 'rspec', cmd: 'bundle exec rspec', all_on_start: true, all_after_pass: true, failed_mode: :focus do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { 'spec' }
  watch('spec/spec_helper.rb')  { 'spec' }
  watch(%r{^spec/(support|matchers|shared)/(.+)\.rb$}) { 'spec' }
end
