class Zendesk2::GetCategory < Zendesk2::Request
  request_method :get
  request_path { |r| "/categories/#{r.category_id}.json" }

  def category_id
    params.fetch("category").fetch("id")
  end

  def mock
    mock_response(
      "category" => self.find!(:categories, category_id)
    )
  end
end
