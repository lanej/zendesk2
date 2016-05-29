# frozen_string_literal: true
class Zendesk2::HelpCenter::Subscriptions
  include Zendesk2::Collection

  include Zendesk2::Searchable

  model Zendesk2::HelpCenter::Subscription

  self.collection_method = :get_help_center_subscriptions
  self.collection_root   = 'subscriptions'
  self.model_method      = :get_help_center_subscription
  self.model_root        = 'subscription'

  attribute :content_id, type: :integer
  attribute :content_type, type: :string
  attribute :count

  scopes << :content_id
  scopes << :content_type
end
