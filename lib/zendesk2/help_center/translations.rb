class Zendesk2::HelpCenter::Translations
  include Zendesk2::Collection

  include Zendesk2::PagedCollection
  include Zendesk2::Searchable

  model Zendesk2::HelpCenter::Translation

  self.collection_method = :get_help_center_translations
  self.collection_root   = "translations"
  self.model_method      = :get_help_center_translation
  self.model_root        = "translation"

  attribute :source_id, type: :integer
  attribute :source_type, type: :string
  attribute :locale, type: :string

  scopes << :source_id
  scopes << :source_type
  scopes << :locale

  def collection_page(params={})
    body = service.send(collection_method, Cistern::Hash.stringify_keys(self.attributes.merge(params))).body

    self.load(body[collection_root])
    self.merge_attributes(Cistern::Hash.slice(body, "count", "next_page", "previous_page"))
    self
  end
end
