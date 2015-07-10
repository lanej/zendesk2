class Zendesk2::Client::GetViews < Zendesk2::Client::Request
  request_method :get
  request_path { |r| "/views.json" }

  page_params!

  def mock
    page(:views)
  end
end
