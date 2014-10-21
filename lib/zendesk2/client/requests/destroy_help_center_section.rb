class Zendesk2::Client::DestroyHelpCenterSection < Zendesk2::Client::Request
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
