class Zendesk2::GetForums < Zendesk2::Request
  request_method :get
  request_path { |_| "/forums.json" }

  page_params!

  def mock
    page(:forums)
  end
end
