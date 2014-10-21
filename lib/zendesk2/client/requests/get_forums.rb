class Zendesk2::Client::GetForums < Zendesk2::Client::Request
  request_method :get
  request_path { |_| "/forums.json" }

  page_params!

  def mock
    page(:forums)
  end
end
