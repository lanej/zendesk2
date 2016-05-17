class Zendesk2::UserFields < Zendesk2::Collection
  include Zendesk2::Searchable

  model Zendesk2::UserField

  attribute :count

  self.collection_method = :get_user_fields
  self.collection_root   = "user_fields"
  self.model_method      = :get_user_field
  self.model_root        = "user_field"
  self.search_type       = "user_field"
end
