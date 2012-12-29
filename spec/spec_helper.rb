ENV['MOCK_ZENDESK'] ||= 'true'

Bundler.require(:test)

require File.expand_path("../../lib/zendesk2", __FILE__)

Dir[File.expand_path("../{support,shared}/**/*.rb", __FILE__)].each {|f| require f}

if ENV["MOCK_ZENDESK"] == 'true'
  Zendesk2::Client.mock!
end

Cistern.formatter = Cistern::Formatter::AwesomePrint

RSpec.configure do |config|
  config.before(:each) do
    Zendesk2::Client.reset! if Zendesk2::Client.mocking?
  end
  config.order = "random"
  config.filter_run_excluding(:mock_only => true) unless Zendesk2::Client.mocking?
end
