class Zendesk2::GetUsers < Zendesk2::Request
  request_method :get
  request_path { "/users.json" }

  page_params!

  def mock(params={})
    page(:users, params)
  end
end
