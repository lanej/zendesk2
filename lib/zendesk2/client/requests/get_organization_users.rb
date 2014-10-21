class Zendesk2::Client::GetOrganizationUsers < Zendesk2::Client::Request
  request_method :get
  request_path { |r| "/organizations/#{r.organization_id}/users.json" }

  page_params!

  def organization_id
    params.fetch("organization").fetch("id")
  end

  def mock
    users = self.data[:users].values.select { |u| u["organization_id"].to_i == organization_id.to_i }

    page(users, root: "users")
  end
end
