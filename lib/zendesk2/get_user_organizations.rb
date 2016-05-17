class Zendesk2::GetUserOrganizations < Zendesk2::Request
  request_method :get
  request_path { |r| "/users/#{r.user_id}/organizations.json" }

  page_params!

  def user_id
    params.fetch("user_id").to_i
  end

  def mock
    memberships = self.data[:memberships].values.select { |m| m["user_id"] == user_id }
    organizations = memberships.map { |m| self.data[:organizations].fetch(m["organization_id"]) }

    page(organizations, root: "organizations")
  end
end
