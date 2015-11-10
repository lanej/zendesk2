class Zendesk2::HelpCenter::Categories < Zendesk2::Collection
  include Zendesk2::PagedCollection
  include Zendesk2::Searchable

  model Zendesk2::HelpCenter::Category

  self.collection_method = :get_help_center_categories
  self.collection_root   = "categories"
  self.model_method      = :get_help_center_category
  self.model_root        = "category"
end
