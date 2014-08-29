require "zendesk2/version"

# dependencies
require 'addressable/uri'
require 'cistern'
require 'faraday'
require 'faraday_middleware'
require 'jwt'

# stdlib
require 'forwardable'
require 'logger'
require 'time'
require 'yaml'
require 'uri'

module Zendesk2
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
    string.nil? || string == ""
  end
end

require 'zendesk2/attributes'
require 'zendesk2/error'
require 'zendesk2/searchable'
require 'zendesk2/logger'
require 'zendesk2/model'
require 'zendesk2/collection'
require 'zendesk2/paged_collection'

require 'zendesk2/client'
