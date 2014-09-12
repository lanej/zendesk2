class Zendesk2::Client::HelpCenter::Articles < Zendesk2::PagedCollection
  include Zendesk2::Searchable

  model Zendesk2::Client::HelpCenter::Article

  self.collection_method = :get_help_center_articles
  self.collection_root   = "help_center_articles"
  self.model_method      = :get_help_center_article
  self.model_root        = "help_center_article"
  self.search_type       = "help_center_article"
end
