class Zendesk2::GetHelpCenterAccessPolicy < Zendesk2::Request
  request_method :get
  request_path { |r|
    "/help_center/sections/#{r.section_id}/access_policy.json"
  }

  def section_id
    params.fetch("section_id")
  end

  def mock(params={})
    mock_response("access_policy" => self.find!(:help_center_access_policies, section_id))
  end
end
