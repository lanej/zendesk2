class Zendesk2::HelpCenter::Articles < Zendesk2::Collection
  include Zendesk2::PagedCollection
  include Zendesk2::Searchable

  model Zendesk2::HelpCenter::Article

  self.collection_method = :get_help_center_articles
  self.collection_root   = "articles"
  self.model_method      = :get_help_center_article
  self.model_root        = "article"
  self.search_type       = nil
  self.search_request    = :search_help_center_articles

  attribute :section_id, type: :integer
  attribute :category_id, type: :integer

  scopes << :section_id
  scopes << :category_id

  def collection_page(params={})
    collection_method = if category_id
                          :get_help_center_categories_articles
                        elsif section_id
                          :get_help_center_sections_articles
                        else
                          :get_help_center_articles
                        end

    body = service.send(collection_method, Cistern::Hash.stringify_keys(self.attributes.merge(params))).body

    self.load(body[collection_root]) # 'results' is the key for paged searches
    self.merge_attributes(Cistern::Hash.slice(body, "count", "next_page", "previous_page"))
    self
  end

end
