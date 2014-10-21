class Zendesk2::Client::GetGroups < Zendesk2::Client::Request
  request_method :get
  request_path { |_| "/groups.json" }

  page_params!

  def mock
    page(:groups, params)
  end
end
