# frozen_string_literal: true
class Zendesk2::DestroyHelpCenterSection
  include Zendesk2::Request

  request_method :delete
  request_path do |r| "/help_center/sections/#{r.section_id}.json" end

  def section_id
    params.fetch('section').fetch('id')
  end

  def mock
    delete!(:help_center_sections, section_id)

    mock_response(nil)
  end
end
