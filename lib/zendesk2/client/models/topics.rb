class Zendesk2::Client::Topics < Zendesk2::Collection
  include Zendesk2::Searchable

  model Zendesk2::Client::Topic

  self.collection_method = :get_topics
  self.collection_root   = "topics"
  self.model_method      = :get_topic
  self.model_root        = "topic"
  self.search_type       = "topic"
end
