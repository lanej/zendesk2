class Zendesk2::Client < Cistern::Service
  USER_AGENT = "Ruby/#{RUBY_VERSION} (#{RUBY_PLATFORM}; #{RUBY_ENGINE}) Zendesk2/#{Zendesk2::VERSION} Faraday/#{Faraday::VERSION}".freeze

  collection_path "zendesk2/client/collections"
  model_path "zendesk2/client/models"
  request_path "zendesk2/client/requests"

  # might be nice if cistern took care of this
  [
    [:collection, collection_path],
    [:model, model_path],
    [:request, request_path],
  ].each do |type, path|
    Dir[File.expand_path(File.join("lib", path, "*.rb"))].each do |file|
      send(type, File.basename(file, ".rb"))
    end
  end

  recognizes :url, :logger, :adapter, :username, :password, :token, :jwt_token

  module Shared
    def require_parameters(params, *requirements)
      if (missing = requirements - params.keys).any?
        raise ArgumentError, "missing parameters: #{missing.join(", ")}"
      end
    end
  end
end

require 'zendesk2/client/real'
require 'zendesk2/client/mock'
