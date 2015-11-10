class Zendesk2::GetOrganizationMemberships < Zendesk2::Request
  request_method :get
  request_path { |r| "/organizations/#{r.organization_id}/organization_memberships.json" }

  page_params!

  def organization_id
    params.fetch("membership").fetch("organization_id").to_i
  end

  def mock
    page(self.data[:memberships].values.select { |m| m["organization_id"] == organization_id }, root: "organization_memberships")
  end
end
