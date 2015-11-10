class Zendesk2::GetHelpCenterSection < Zendesk2::Request
  request_method :get
  request_path { |r|
    if locale = r.params.fetch("section")["locale"]
      "/help_center/#{locale}/sections/#{r.section_id}.json"
    else
      "/help_center/sections/#{r.section_id}.json"
    end
  }

  def section_id
    params.fetch("section").fetch("id")
  end

  def mock(params={})
    mock_response("section" => self.find!(:help_center_sections, section_id))
  end
end
