require 'logger'

module ClientHelper
  def create_client(options={})
    options.merge!(logger: Logger.new(STDOUT)) if ENV['VERBOSE']
    options = {username: "zendesk2@example.org", password: "password"}.merge(Zendesk2.defaults).merge(options)
    Zendesk2::Client.new(options)
  end
end

RSpec.configure do |config|
  config.include(ClientHelper)
end
