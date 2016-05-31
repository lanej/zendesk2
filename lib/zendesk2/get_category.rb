# frozen_string_literal: true
class Zendesk2::GetCategory
  include Zendesk2::Request

  request_method :get
  request_path do |r| "/categories/#{r.category_id}.json" end

  def category_id
    params.fetch('category').fetch('id')
  end

  def mock
    mock_response(
      'category' => find!(:categories, category_id)
    )
  end
end
