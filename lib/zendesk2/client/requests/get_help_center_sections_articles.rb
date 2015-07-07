class Zendesk2::Client::GetHelpCenterSectionsArticles < Zendesk2::Client::Request
  request_path { |r|
    "/help_center/sections/#{r.section_id}/articles.json"
  }

  page_params!

  def section_id
    Integer(
      params.fetch("section_id")
    )
  end

  def mock
    self.find!(:help_center_sections, section_id)

    mock_response("articles" => self.data[:help_center_articles].values.select { |s| s["section_id"] == section_id })
  end
end
