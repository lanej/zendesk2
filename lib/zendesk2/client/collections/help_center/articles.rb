class Zendesk2::Client::HelpCenter::Articles < Zendesk2::Client::Collection
  include Zendesk2::PagedCollection
  include Zendesk2::Searchable

  model Zendesk2::Client::HelpCenter::Article

  self.collection_method = :get_help_center_articles
  self.collection_root   = "articles"
  self.model_method      = :get_help_center_article
  self.model_root        = "article"
  self.search_type       = nil
  self.search_request    = :search_help_center_articles

end
