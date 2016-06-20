# frozen_string_literal: true
class Zendesk2::GetHelpCenterCategoriesArticles
  include Zendesk2::Request

  request_path do |r|
    "/help_center/categories/#{r.category_id}/articles.json"
  end

  page_params!

  def category_id
    Integer(
      params.fetch('category_id')
    )
  end

  def mock
    find!(:help_center_categories, category_id)

    mock_response('articles' => data[:help_center_articles].values.select do |s|
      data[:help_center_sections].fetch(s['section_id'])['category_id'] == category_id
    end)
  end
end
