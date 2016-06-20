# frozen_string_literal: true
class Zendesk2::DestroyHelpCenterCategory
  include Zendesk2::Request

  request_path { |r| "/help_center/categories/#{r.category_id}.json" }
  request_method :delete

  def category_id
    params.fetch('category').fetch('id')
  end

  def mock
    mock_response('category' => delete!(:help_center_categories, category_id))
  end
end
