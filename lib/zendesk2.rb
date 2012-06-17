require "zendesk2/version"

require 'cistern'
require 'addressable/uri'
require 'faraday'
require 'faraday_middleware'

require 'time'

module Zendesk2
  autoload :Client, "zendesk2/client"
  autoload :PagedCollection, "zendesk2/paged_collection"

  def self.defaults
    @defaults ||= if File.exists?(File.expand_path("~/.zendesk2"))
                    YAML.load_file(File.expand_path("~/.zendesk2"))
                  else
                    {}
                  end
  end
end

Zendesk = Zendesk2
