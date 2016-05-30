# frozen_string_literal: true
class Zendesk2::HelpCenter::Translations
  include Zendesk2::Collection

  include Zendesk2::PagedCollection
  include Zendesk2::Searchable

  model Zendesk2::HelpCenter::Translation

  self.collection_method = :get_help_center_translations
  self.collection_root   = 'translations'
  self.model_method      = :get_help_center_translation
  self.model_root        = 'translation'

  attribute :source_id, type: :integer
  attribute :source_type, type: :string
  attribute :locale, type: :string
  attribute :locales, type: :array
  attribute :outdated, type: :boolean
  attribute :draft, type: :boolean

  scopes << :source_id
  scopes << :source_type

  scopes << :locale
  scopes << :locales

  scopes << :outdated
  scopes << :draft
end
