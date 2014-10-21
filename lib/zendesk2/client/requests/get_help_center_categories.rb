class Zendesk2::Client::GetHelpCenterCategories < Zendesk2::Client::Request
  request_path { |_| "/help_center/categories.json" }

  page_params!

  def mock
    page(:help_center_categories, root: "categories")
  end
end
