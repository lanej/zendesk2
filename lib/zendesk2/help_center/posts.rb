# frozen_string_literal: true
class Zendesk2::HelpCenter::Posts
  include Zendesk2::Collection
  include Zendesk2::PagedCollection

  model Zendesk2::HelpCenter::Post

  self.collection_method = :get_help_center_posts
  self.collection_root   = 'posts'
  self.model_method      = :get_help_center_post
  self.model_root        = 'post'

  attribute :user_id, type: :integer
  attribute :topic_id, type: :integer

  scopes << :user_id
  scopes << :topic_id
end
