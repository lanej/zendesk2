require 'logger'

module ClientHelper
  def create_client(options={})
    options.merge!(logger: Logger.new(STDOUT)) if ENV['VERBOSE']
    Zendesk2::Client.new(default_params.merge(options))
  end
end

RSpec.configure do |config|
  config.include(ClientHelper)
end
