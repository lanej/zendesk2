class Zendesk2::Client::GetUserMemberships < Zendesk2::Client::Request
  request_method :get
  request_path  { |r| "/users/#{r.user_id}/organization_memberships.json" }

  page_params!

  def user_id
    params.fetch("membership").fetch("user_id").to_i
  end

  def mock
    collection = self.data[:memberships].values.select { |m| m["user_id"] == user_id }

    resources(collection, root: "organization_memberships")
  end
end
