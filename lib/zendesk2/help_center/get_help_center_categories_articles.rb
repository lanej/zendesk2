class Zendesk2::GetHelpCenterCategoriesArticles < Zendesk2::Request
  request_path { |r|
    "/help_center/categories/#{r.category_id}/articles.json"
  }

  page_params!

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
