class Zendesk2::Client::Organizations < Cistern::Collection
  include Zendesk2::PagedCollection
  include Zendesk2::Searchable

  model Zendesk2::Client::Organization

  self.collection_method= :get_organizations
  self.collection_root= "organizations"
  self.model_method= :get_organization
  self.model_root= "organization"
  self.search_type= "organization"

  def current
    new(connection.get_current_organization.body["organization"])
  end
end
