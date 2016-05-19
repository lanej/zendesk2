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

require 'zendesk2/real'
require 'zendesk2/mock'
require 'zendesk2/request'
require 'zendesk2/model'
require 'zendesk2/collection'
require 'zendesk2/help_center'

require 'zendesk2/create_category'
require 'zendesk2/create_forum'
require 'zendesk2/create_group'
require 'zendesk2/create_membership'
require 'zendesk2/create_organization'
require 'zendesk2/create_ticket'
require 'zendesk2/create_ticket_field'
require 'zendesk2/create_topic'
require 'zendesk2/create_topic_comment'
require 'zendesk2/create_user'
require 'zendesk2/create_user_field'
require 'zendesk2/create_user_identity'
require 'zendesk2/create_view'
require 'zendesk2/destroy_category'
require 'zendesk2/destroy_forum'
require 'zendesk2/destroy_group'
require 'zendesk2/destroy_membership'
require 'zendesk2/destroy_organization'
require 'zendesk2/destroy_ticket'
require 'zendesk2/destroy_ticket_field'
require 'zendesk2/destroy_topic'
require 'zendesk2/destroy_topic_comment'
require 'zendesk2/destroy_user'
require 'zendesk2/destroy_user_field'
require 'zendesk2/destroy_user_identity'
require 'zendesk2/destroy_view'
require 'zendesk2/get_assignable_groups'
require 'zendesk2/get_categories'
require 'zendesk2/get_category'
require 'zendesk2/get_ccd_tickets'
require 'zendesk2/get_current_user'
require 'zendesk2/get_forum'
require 'zendesk2/get_forums'
require 'zendesk2/get_group'
require 'zendesk2/get_groups'
require 'zendesk2/get_membership'
require 'zendesk2/get_memberships'
require 'zendesk2/get_organization'
require 'zendesk2/get_organization_by_external_id'
require 'zendesk2/get_organization_memberships'
require 'zendesk2/get_organization_tickets'
require 'zendesk2/get_organization_users'
require 'zendesk2/get_organizations'
require 'zendesk2/get_requested_tickets'
require 'zendesk2/get_ticket'
require 'zendesk2/get_ticket_audit'
require 'zendesk2/get_ticket_audits'
require 'zendesk2/get_ticket_comments'
require 'zendesk2/get_ticket_field'
require 'zendesk2/get_ticket_fields'
require 'zendesk2/get_tickets'
require 'zendesk2/get_topic'
require 'zendesk2/get_topic_comment'
require 'zendesk2/get_topic_comments'
require 'zendesk2/get_topics'
require 'zendesk2/get_user'
require 'zendesk2/get_user_field'
require 'zendesk2/get_user_fields'
require 'zendesk2/get_user_identities'
require 'zendesk2/get_user_identity'
require 'zendesk2/get_user_memberships'
require 'zendesk2/get_user_organizations'
require 'zendesk2/get_users'
require 'zendesk2/get_view'
require 'zendesk2/get_view_tickets'
require 'zendesk2/get_views'
require 'zendesk2/mark_membership_default'
require 'zendesk2/mark_user_identity_primary'
require 'zendesk2/update_category'
require 'zendesk2/update_forum'
require 'zendesk2/update_group'
require 'zendesk2/update_organization'
require 'zendesk2/update_ticket'
require 'zendesk2/update_ticket_field'
require 'zendesk2/update_topic'
require 'zendesk2/update_user'
require 'zendesk2/update_user_field'
require 'zendesk2/update_user_identity'
require 'zendesk2/update_view'

require 'zendesk2/search'
require 'zendesk2/search_organization'
require 'zendesk2/search_user'

require 'zendesk2/audit_event'

require 'zendesk2/category'
require 'zendesk2/forum'
require 'zendesk2/group'
require 'zendesk2/membership'
require 'zendesk2/organization'
require 'zendesk2/ticket'
require 'zendesk2/ticket_audit'
require 'zendesk2/ticket_comment'
require 'zendesk2/ticket_field'
require 'zendesk2/topic'
require 'zendesk2/topic_comment'
require 'zendesk2/user'
require 'zendesk2/user_field'
require 'zendesk2/user_identity'
require 'zendesk2/view'

require 'zendesk2/categories'
require 'zendesk2/forums'
require 'zendesk2/groups'
require 'zendesk2/memberships'
require 'zendesk2/organizations'
require 'zendesk2/ticket_audits'
require 'zendesk2/ticket_comments'
require 'zendesk2/ticket_fields'
require 'zendesk2/tickets'
require 'zendesk2/topic_comments'
require 'zendesk2/topics'
require 'zendesk2/user_fields'
require 'zendesk2/user_identities'
require 'zendesk2/users'
require 'zendesk2/views'
