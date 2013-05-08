class Zendesk2::Client::Organizations < Zendesk2::Collection
  include Zendesk2::Searchable

  model Zendesk2::Client::Organization

  self.collection_method = :get_organizations
  self.collection_root   = "organizations"
  self.model_method      = :get_organization
  self.model_root        = "organization"
  self.search_type       = "organization"
  self.search_options    = {
    direct_query:            true,
    path:                    "/organizations/search.json",
    results_collection_name: "organizations",
  }
end
