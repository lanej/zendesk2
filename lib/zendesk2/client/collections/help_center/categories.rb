class Zendesk2::Client::HelpCenter::Categories < Zendesk2::PagedCollection
  include Zendesk2::Searchable

  model Zendesk2::Client::HelpCenter::Category

  self.collection_method = :get_help_center_categories
  self.collection_root   = "categories"
  self.model_method      = :get_help_center_category
  self.model_root        = "category"
end
