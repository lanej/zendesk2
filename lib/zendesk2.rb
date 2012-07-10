require "zendesk2/version"

require 'cistern'
require 'addressable/uri'
require 'faraday'
require 'faraday_middleware'

require 'time'

module Zendesk2
  require 'zendesk2/error'
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
    [8,4,4,4,12].map{|i| Cistern::Mock.random_hex(i)}.join("-")
  end

  def self.stringify_keys(hash)
    hash.inject({}){|r,(k,v)| r.merge(k.to_s => v)}
  end

  def self.blank?(string)
    !!string || string == ""
  end
end
