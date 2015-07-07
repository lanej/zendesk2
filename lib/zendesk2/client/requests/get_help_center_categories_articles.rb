class Zendesk2::Client::GetHelpCenterCategoriesArticles < Zendesk2::Client::Request
  request_path { |r|
    "/help_center/categories/#{r.category_id}/articles.json"
  }

  def category_id
    Integer(
      params.fetch("category_id")
    )
  end

  def mock
    self.find!(:help_center_categories, category_id)

    mock_response("articles" => self.data[:help_center_articles].values.select { |s|
      self.data[:help_center_sections].fetch(s["section_id"])["category_id"] == category_id
    })
  end
end
