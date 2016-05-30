# frozen_string_literal: true
class Zendesk2::GetHelpCenterCategory
  include Zendesk2::Request

  request_path do |r|
    locale = r.params.fetch('category')['locale']
    locale ? "/help_center/#{locale}/categories/#{r.category_id}.json" : "/help_center/categories/#{r.category_id}.json"
  end

  def category_id
    params.fetch('category').fetch('id')
  end

  def mock
    mock_response('category' => find!(:help_center_categories, category_id))
  end
end
