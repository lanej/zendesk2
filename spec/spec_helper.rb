# frozen_string_literal: true
ENV['MOCK_ZENDESK'] ||= 'true'

Bundler.require(:test)

require File.expand_path('../../lib/zendesk2', __FILE__)

Dir[File.expand_path('../{support,shared}/**/*.rb', __FILE__)].each do |f| require f end

Zendesk2.mock! if ENV['MOCK_ZENDESK'] == 'true'

Cistern.formatter = Cistern::Formatter::AwesomePrint
Cistern.deprecation_warnings = ENV['DEBUG']

RSpec.configure do |config|
  Zendesk2.mocking? ? config.before(:each) { Zendesk2.reset! } : config.filter_run_excluding(mock_only: true)
  config.filter_run(focus: true)
  config.run_all_when_everything_filtered = true

  config.order = 'random'
end
