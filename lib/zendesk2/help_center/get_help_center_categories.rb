# frozen_string_literal: true
class Zendesk2::GetHelpCenterCategories
  include Zendesk2::Request

  request_path do |_| '/help_center/categories.json' end

  page_params!

  def mock
    page(:help_center_categories, root: 'categories')
  end
end
