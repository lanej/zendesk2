# frozen_string_literal: true
class Zendesk2::GetHelpCenterAccessPolicy
  include Zendesk2::Request

  request_method :get
  request_path do |r|
    "/help_center/sections/#{r.section_id}/access_policy.json"
  end

  def section_id
    params.fetch('section_id')
  end

  def mock(_params = {})
    mock_response('access_policy' => find!(:help_center_access_policies, section_id))
  end
end
