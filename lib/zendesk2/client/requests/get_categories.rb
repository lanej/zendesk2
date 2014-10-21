class Zendesk2::Client::GetCategories < Zendesk2::Client::Request
  request_method :get
  request_path { |_| "/categories.json" }

  page_params!

  def mock
    page(:categories)
  end
end
