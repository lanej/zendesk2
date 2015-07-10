class Zendesk2::Client < Cistern::Service
  USER_AGENT = "Ruby/#{RUBY_VERSION} (#{RUBY_PLATFORM}; #{RUBY_ENGINE}) Zendesk2/#{Zendesk2::VERSION} Faraday/#{Faraday::VERSION}".freeze

  recognizes :url, :logger, :adapter, :username, :password, :token, :jwt_token
end

def require_resource(resource, options={})
  plural = options[:plural] || "#{resource}s"
  except = Array(options[:except])
  other  = Array(options[:and])

  require "zendesk2/client/models/#{resource}"
  require "zendesk2/client/collections/#{plural}"

  require "zendesk2/client/requests/create_#{resource}"  unless except.include?(:create)
  require "zendesk2/client/requests/destroy_#{resource}" unless except.include?(:destroy)
  require "zendesk2/client/requests/get_#{plural}"       unless except.include?(:index)
  require "zendesk2/client/requests/get_#{resource}"     unless except.include?(:show)
  require "zendesk2/client/requests/update_#{resource}"  unless except.include?(:update)

  other.each { |file| require "zendesk2/client/requests/#{file}" }
end

require 'zendesk2/client/real'
require 'zendesk2/client/mock'
require 'zendesk2/client/request'
require 'zendesk2/client/model'
require 'zendesk2/client/collection'
require 'zendesk2/client/help_center'

require 'zendesk2/client/requests/search'
require 'zendesk2/client/models/audit_event'

require_resource("category", plural: "categories")
require_resource("forum")
require_resource("group", and: ["get_assignable_groups"])
require_resource("user", and: [
  "search_user",
  "get_current_user",
  "mark_user_identity_primary",
  "get_user_memberships",
  "get_user_organizations",
])

require_resource("ticket", and: ["get_requested_tickets", "get_ccd_tickets"])
require_resource("ticket_audit", except: [:create, :destroy, :update])
require_resource("ticket_field")
require_resource("topic")
require_resource("topic_comment", except: [:update])
require_resource("ticket_comment", except: [:create, :destroy, :update, :show])
require_resource("organization", and: [
  "get_organization_users",
  "get_organization_tickets",
  "get_organization_by_external_id",
  "get_organization_memberships",
  "search_organization",
])
require_resource("user_field")
require_resource("user_identity", plural: "user_identities")
require_resource("membership", except: [:update], and: "mark_membership_default")
require_resource("view")
