class Zendesk2::Client::GetOrganizations < Zendesk2::Client::Request
  request_method :get
  request_path { |_| "/organizations.json" }

  page_params!

  def mock
    page(:organizations)
  end
end
