class Zendesk2::Client::TopicComments < Zendesk2::Collection
  include Zendesk2::Searchable

  model Zendesk2::Client::TopicComment

  attribute :topic_id, type: :integer

  self.collection_method = :get_topic_comments
  self.collection_root   = "topic_comments"
  self.model_method      = :get_topic_comment
  self.model_root        = "topic_comment"
  self.search_type       = "topic_comment"

  scopes << :topic_id
end
