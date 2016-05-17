class Zendesk2::GetHelpCenterCategory < Zendesk2::Request
  request_path { |r|
    if locale = r.params.fetch("category")["locale"]
      "/help_center/#{locale}/categories/#{r.category_id}.json"
    else
      "/help_center/categories/#{r.category_id}.json"
    end
  }

  def category_id
    params.fetch("category").fetch("id")
  end

  def mock
    mock_response("category" => self.find!(:help_center_categories, category_id))
  end
end
