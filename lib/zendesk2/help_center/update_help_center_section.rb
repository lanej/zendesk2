# frozen_string_literal: true
class Zendesk2::UpdateHelpCenterSection
  include Zendesk2::Request

  request_method :put
  request_body { |r| { 'section' => r.section_params } }
  request_path do |r|
    locale = r.section_params['locale']
    locale ? "/help_center/#{locale}/sections/#{r.section_id}.json" : "/help_center/sections/#{r.section_id}.json"
  end

  def section_params
    Cistern::Hash.slice(params.fetch('section'), *Zendesk2::CreateHelpCenterSection.accepted_attributes)
  end

  def section_id
    params.fetch('section').fetch('id')
  end

  def mock
    mock_response('section' => find!(:help_center_sections, section_id).merge!(section_params))
  end
end
