# frozen_string_literal: true
class Zendesk2::UpdateHelpCenterCategory
  include Zendesk2::Request

  request_method :put
  request_body do |r| { 'category' => r.category_params } end
  request_path do |r|
    locale = r.category_params['locale']
    locale ? "/help_center/#{locale}/categories/#{r.category_id}.json" : "/help_center/categories/#{r.category_id}.json"
  end

  def category_params
    Cistern::Hash.slice(params.fetch('category'), *Zendesk2::CreateHelpCenterCategory.accepted_attributes)
  end

  def category_id
    params.fetch('category').fetch('id')
  end

  def mock
    mock_response('category' => find!(:help_center_categories, category_id).merge!(category_params))
  end
end
