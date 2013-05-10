class Zendesk2::Client::Organizations < Zendesk2::Collection
  include Zendesk2::Searchable

  model Zendesk2::Client::Organization

  def find_by_external_id(external_id)
    body = connection.get_organization_by_external_id(external_id).body
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
end
