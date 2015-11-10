class Zendesk2::DestroyHelpCenterSection < Zendesk2::Request
  request_method :delete
  request_path { |r| "/help_center/sections/#{r.section_id}.json" }

  def section_id
    params.fetch("section").fetch("id")
  end

  def mock
    self.delete!(:help_center_sections, section_id)

    mock_response(nil)
  end
end
