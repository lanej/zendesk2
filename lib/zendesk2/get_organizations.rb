class Zendesk2::GetOrganizations < Zendesk2::Request
  request_method :get
  request_path { |_| "/organizations.json" }

  page_params!

  def mock
    page(:organizations)
  end
end
