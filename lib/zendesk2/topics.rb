class Zendesk2::Topics < Zendesk2::Collection
  include Zendesk2::PagedCollection
  include Zendesk2::Searchable

  model Zendesk2::Topic

  self.collection_method = :get_topics
  self.collection_root   = "topics"
  self.model_method      = :get_topic
  self.model_root        = "topic"
  self.search_type       = "topic"
end
