module ClientHelper
  def create_client(options={})
    default_params = if File.exists?(File.expand_path("~/.zendesk2"))
                       YAML.load_file(File.expand_path("~/.zendesk2"))
                     else
                       {}
                     end
    Zendesk::Client.new(default_params.merge(options))
  end
end

RSpec.configure do |config|
  config.include(ClientHelper)
end
