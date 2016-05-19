class Zendesk2::GetHelpCenterSections
  include Zendesk2::Request

  request_path { |_| "/help_center/sections.json" }

  page_params!

  def mock
    page(:help_center_sections, root: "sections")
  end
end
