class Zendesk2::Client < Cistern::Service
  USER_AGENT = "Ruby/#{RUBY_VERSION} (#{RUBY_PLATFORM}; #{RUBY_ENGINE}) Zendesk2/#{Zendesk2::VERSION} Faraday/#{Faraday::VERSION}".freeze

  collection_path "zendesk2/client/collections"
  model_path      "zendesk2/client/models"
  request_path    "zendesk2/client/requests"

  # @fixme might be nice if cistern took care of this
  [
    [:collection, collection_path],
    [:model,      model_path],
    [:request,    request_path],
  ].each do |type, path|
    Dir[File.expand_path(File.join("../..", path, "**/*.rb"), __FILE__)].sort.each do |file|
      send(type, file.gsub(/.*#{path}\/(.*)\.rb/, "\\1"), require: file)
    end
  end

  recognizes :url, :logger, :adapter, :username, :password, :token, :jwt_token

  module Shared
    def require_parameters(_params, *requirements)
      params = Cistern::Hash.stringify_keys(_params)

      if (missing = requirements - params.keys).any?
        raise ArgumentError, "missing parameters: #{missing.join(", ")}"
      else
        values = params.values_at(*requirements)
        requirements.size == 1 ? values.first : values
      end
    end
  end
end

require 'zendesk2/client/real'
require 'zendesk2/client/mock'
require 'zendesk2/client/help_center'
