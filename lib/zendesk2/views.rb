# frozen_string_literal: true
class Zendesk2::Views
  include Zendesk2::Collection

  include Zendesk2::PagedCollection
  extend Zendesk2::Attributes

  model Zendesk2::View

  self.collection_method = :get_views
  self.collection_root   = 'views'
  self.model_method      = :get_view
  self.model_root        = 'view'
end
