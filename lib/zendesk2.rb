require "zendesk2/version"

# dependencies
require 'cistern'
require 'faraday'
require 'faraday_middleware'
require 'jwt'
require 'uri'

# stdlib
require 'forwardable'
require 'logger'
require 'time'
require 'yaml'
require 'securerandom'

class Zendesk2
  include Cistern::Client

  USER_AGENT = "Ruby/#{RUBY_VERSION} (#{RUBY_PLATFORM}; #{RUBY_ENGINE}) Zendesk2/#{Zendesk2::VERSION} Faraday/#{Faraday::VERSION}".freeze

  def self.defaults
    @defaults ||= begin
                    YAML.load_file(File.expand_path("~/.zendesk2"))
                  rescue ArgumentError, Errno::ENOENT
                    # handle missing home directories or missing file
                    {}
                  end
  end

  def self.stringify_keys(hash)
    hash.inject({}) { |r,(k,v)| r.merge(k.to_s => v) }
  end

  def self.blank?(string)
    string.nil? || string == ""
  end


  recognizes :url, :logger, :adapter, :username, :password, :token, :jwt_token
end

require 'zendesk2/attributes'
require 'zendesk2/error'
require 'zendesk2/searchable'
require 'zendesk2/logger'
require 'zendesk2/paged_collection'
require 'zendesk2/rate_limit'

require 'zendesk2/client'
