class Zendesk2::Forums < Zendesk2::Collection
  include Zendesk2::PagedCollection
  include Zendesk2::Searchable

  model Zendesk2::Forum

  self.collection_method = :get_forums
  self.collection_root   = "forums"
  self.model_method      = :get_forum
  self.model_root        = "forum"
  self.search_type       = "forum"
end
