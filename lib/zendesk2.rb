require "zendesk2/version"

module Zendesk2
  autoload :Client, "zendesk2/client"

  def self.defaults
    @defaults ||= if File.exists?(File.expand_path("~/.zendesk2"))
                    YAML.load_file(File.expand_path("~/.zendesk2"))
                  else
                    {}
                  end
  end
end

Zendesk = Zendesk2
