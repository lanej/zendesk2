# frozen_string_literal: true
class Zendesk2::UpdateCategory
  include Zendesk2::Request

  request_method :put
  request_body do |r| { 'category' => Cistern::Hash.except(r.category, 'id') } end
  request_path do |r| "/categories/#{r.category_id}.json" end

  def category
    params.fetch('category')
  end

  def category_id
    category.fetch('id')
  end

  def mock
    category_data = find!(:categories, category_id)
    category_data.merge!(Cistern::Hash.slice(category, *Zendesk2::CreateCategory.accepted_attributes))

    mock_response('category' => category_data)
  end
end
