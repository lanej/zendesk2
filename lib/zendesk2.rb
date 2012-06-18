require "zendesk2/version"

require 'cistern'
require 'addressable/uri'
require 'faraday'
require 'faraday_middleware'
require 'uuidtools'

require 'time'

module Zendesk2
  require 'zendesk2/errors'
  autoload :Client, "zendesk2/client"
  autoload :PagedCollection, "zendesk2/paged_collection"

  def self.defaults
    @defaults ||= if File.exists?(File.expand_path("~/.zendesk2"))
                    YAML.load_file(File.expand_path("~/.zendesk2"))
                  else
                    {}
                  end
  end

  def self.paging_parameters(options={})
    if url = options["url"]
      uri = Addressable::URI.parse(url)
      uri.query_values
    else
      Cistern::Hash.slice(options, "page", "per_page")
    end
  end

  def self.uuid
    UUIDTools::UUID.random_create.to_s
  end
end

Zendesk = Zendesk2
