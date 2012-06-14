ENV['MOCK_ZENDESK'] ||= 'true'

Bundler.require(:test)

require File.expand_path("../../lib/zendesk2", __FILE__)

Dir["./spec/{support,shared}/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.before(:all) do
    Zendesk::Client.reset! if Zendesk::Client.mocking?
  end
end
