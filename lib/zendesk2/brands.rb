# frozen_string_literal: true
class Zendesk2::Brands
  include Zendesk2::Collection

  model Zendesk2::Brand

  attribute :count, type: :integer

  self.collection_method = :get_brands
  self.collection_root   = 'brands'
  self.model_method      = :get_brand
  self.model_root        = 'brand'
end
