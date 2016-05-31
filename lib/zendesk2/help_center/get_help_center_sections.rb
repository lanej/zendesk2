# frozen_string_literal: true
class Zendesk2::GetHelpCenterSections
  include Zendesk2::Request

  request_path do |_| '/help_center/sections.json' end

  page_params!

  def mock
    page(:help_center_sections, root: 'sections')
  end
end
