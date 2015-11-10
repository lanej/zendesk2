class Zendesk2::Organizations < Zendesk2::Collection
  include Zendesk2::PagedCollection
  include Zendesk2::Searchable
  extend Zendesk2::Attributes

  model Zendesk2::Organization

  attribute :user_id, type: :integer

  assoc_accessor :user

  def find_by_external_id(external_id)
    body = service.get_organization_by_external_id("external_id" => external_id).body
    if data = body.delete("organizations")
      collection = self.clone.load(data)
      collection.merge_attributes(Cistern::Hash.slice(body, "count", "next_page", "previous_page"))
      collection
    end
  end

  self.collection_method = :get_organizations
  self.collection_root   = "organizations"
  self.model_method      = :get_organization
  self.model_root        = "organization"
  self.search_type       = "organization"
  self.search_request    = :search_organization

  def collection_page(params={})
    collection_method = if self.user_id
                          :get_user_organizations
                        else
                          :get_organizations
                        end

    body = service.send(collection_method, Cistern::Hash.stringify_keys(self.attributes.merge(params))).body

    self.load(body[collection_root])
    self.merge_attributes(Cistern::Hash.slice(body, "count", "next_page", "previous_page"))
    self
  end
end
