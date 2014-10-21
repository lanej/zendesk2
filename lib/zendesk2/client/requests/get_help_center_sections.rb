class Zendesk2::Client::GetHelpCenterSections < Zendesk2::Client::Request
  request_path { |_| "/help_center/sections.json" }

  page_params!

  def mock
    page(:help_center_sections, root: "sections")
  end
end
