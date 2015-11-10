class Zendesk2::UpdateHelpCenterSection < Zendesk2::Request
  request_method :put
  request_body { |r| { "section" => r.section_params } }
  request_path { |r|
    if locale = r.section_params["locale"]
      "/help_center/#{locale}/sections/#{r.section_id}.json"
    else
      "/help_center/sections/#{r.section_id}.json"
    end
  }

  def section_params
    @_section_params ||= Cistern::Hash.slice(params.fetch("section"), *Zendesk2::CreateHelpCenterSection.accepted_attributes)
  end

  def section_id
    params.fetch("section").fetch("id")
  end

  def mock
    mock_response("section" => self.find!(:help_center_sections, section_id).merge!(section_params))
  end
end
