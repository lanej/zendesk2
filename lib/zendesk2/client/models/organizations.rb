class Zendesk2::Client::Organizations < Cistern::Collection
  include Zendesk2::PagedCollection

  model Zendesk2::Client::Organization

  self.collection_method= :get_organizations
  self.collection_root= "organizations"
  self.model_method= :get_organization
  self.model_root= "organization"

  def current
    new(connection.get_current_organization.body["organization"])
  end

  def search(parameters)
    body = connection.search(parameters.merge("type" => "organization")).body
    if data = body.delete("results")
      load(data)
    end
    merge_attributes(body)
  end
end
