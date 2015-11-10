def Kernel.require(file)
  puts "require '#{file}'"
  super
end

def require_resource(resource, options={})
  plural = options[:plural] || "#{resource}s"
  except = Array(options[:except])
  other  = Array(options[:and])

  require "zendesk2/models/#{resource}"
  require "zendesk2/collections/#{plural}"

  require "zendesk2/requests/create_#{resource}"  unless except.include?(:create)
  require "zendesk2/requests/destroy_#{resource}" unless except.include?(:destroy)
  require "zendesk2/requests/get_#{plural}"       unless except.include?(:index)
  require "zendesk2/requests/get_#{resource}"     unless except.include?(:show)
  require "zendesk2/requests/update_#{resource}"  unless except.include?(:update)

  other.each { |file| require "zendesk2/requests/#{file}" }
end

require 'zendesk2/real'
require 'zendesk2/mock'
require 'zendesk2/request'
require 'zendesk2/model'
require 'zendesk2/collection'
require 'zendesk2/help_center'

require 'zendesk2/requests/search'
require 'zendesk2/models/audit_event'

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
require_resource("view", and: ["get_view_tickets"])

def Kernel.require(file)
  super
end
