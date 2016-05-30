# frozen_string_literal: true
class Zendesk2::GetHelpCenterSection
  include Zendesk2::Request

  request_method :get
  request_path do |r|
    locale = r.params.fetch('section')['locale']
    locale ? "/help_center/#{locale}/sections/#{r.section_id}.json" : "/help_center/sections/#{r.section_id}.json"
  end

  def section_id
    params.fetch('section').fetch('id')
  end

  def mock(_params = {})
    mock_response('section' => find!(:help_center_sections, section_id))
  end
end
