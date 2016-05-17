class Zendesk2::GetViews < Zendesk2::Request
  request_method :get
  request_path { |r| "/views.json" }

  page_params!

  def mock
    page(:views)
  end
end
