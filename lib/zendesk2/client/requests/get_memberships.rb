class Zendesk2::Client::GetMemberships < Zendesk2::Client::Request
  request_method :get
  request_path { |r| "/organization_memberships.json" }

  page_params!

  def mock
    page(self.data[:memberships].values, root: "organization_memberships")
  end
end
