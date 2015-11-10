class Zendesk2::GetHelpCenterCategoriesSections < Zendesk2::Request
  request_path { |r|
    "/help_center/categories/#{r.category_id}/sections.json"
  }

  page_params!

  def category_id
    Integer(
      params.fetch("category_id")
    )
  end

  def mock
    self.find!(:help_center_categories, category_id)

    mock_response("sections" => self.data[:help_center_sections].values.select { |s| s["category_id"] == category_id })
  end
end
