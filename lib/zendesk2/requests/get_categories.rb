class Zendesk2::GetCategories < Zendesk2::Request
  request_method :get
  request_path { |_| "/categories.json" }

  page_params!

  def mock
    page(:categories)
  end
end
