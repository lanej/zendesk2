class Zendesk2::GetGroups < Zendesk2::Request
  request_method :get
  request_path { |_| "/groups.json" }

  page_params!

  def mock
    page(:groups, params)
  end
end
