class Zendesk2::Client::Categories < Zendesk2::Collection
  include Zendesk2::Searchable

  model Zendesk2::Client::Category

  self.collection_method = :get_categories
  self.collection_root   = "categories"
  self.model_method      = :get_category
  self.model_root        = "category"
  self.search_type       = "category"
end
