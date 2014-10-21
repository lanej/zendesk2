class Zendesk2::Client::GetUsers < Zendesk2::Client::Request
  request_method :get
  request_path { "/users.json" }

  page_params!

  def mock(params={})
    page(:users, params)
  end
end
