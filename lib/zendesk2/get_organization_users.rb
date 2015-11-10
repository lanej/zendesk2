class Zendesk2::GetOrganizationUsers < Zendesk2::Request
  request_method :get
  request_path { |r| "/organizations/#{r.organization_id}/users.json" }

  page_params!

  def organization_id
    params.fetch("organization").fetch("id").to_i
  end

  def mock
    users = self.data[:memberships].values.
      select { |m| m["organization_id"] == organization_id }.
      map    { |m| self.data[:users].fetch(m["user_id"]) }

    page(users, root: "users")
  end
end
