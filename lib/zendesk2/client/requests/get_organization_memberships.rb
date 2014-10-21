class Zendesk2::Client::GetOrganizationMemberships < Zendesk2::Client::Request
  request_method :get
  request_path { |r| "/organizations/#{r.organization_id}/memberships.json" }

  def organization_id
    params.fetch("membership").fetch("organization_id").to_i
  end

  def mock
    memberships = self.data[:memberships].values.select { |m| m["organization_id"] == organization_id }

    resources(memberships, root: "organization_memberships")
  end
end
