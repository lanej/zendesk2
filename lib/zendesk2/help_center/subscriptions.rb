# frozen_string_literal: true
class Zendesk2::HelpCenter::Subscriptions
  include Zendesk2::Collection
  include Zendesk2::PagedCollection

  include Zendesk2::Searchable

  model Zendesk2::HelpCenter::Subscription

  self.collection_method = :get_help_center_subscriptions
  self.collection_root   = 'subscriptions'
  self.model_method      = :get_help_center_subscription
  self.model_root        = 'subscription'

  attribute :content_id, type: :integer
  attribute :content_type, type: :string
  attribute :user_id, type: :integer

  scopes << :content_id
  scopes << :content_type
  scopes << :user_id

  def collection_method
    user_id ? :get_users_help_center_subscriptions : super
  end

  def get!(*args)
    requires :content_id, :content_type

    super
  end
end
