class Zendesk2::UpdateHelpCenterCategory < Zendesk2::Request
  request_method :put
  request_body { |r| { "category" => r.category_params } }
  request_path { |r|
    if locale = r.category_params["locale"]
      "/help_center/#{locale}/categories/#{r.category_id}.json"
    else
      "/help_center/categories/#{r.category_id}.json"
    end
  }

  def category_params
    @_category_params ||= Cistern::Hash.slice(params.fetch("category"), *Zendesk2::CreateHelpCenterCategory.accepted_attributes)
  end

  def category_id
    params.fetch("category").fetch("id")
  end

  def mock
    mock_response("category" => self.find!(:help_center_categories, self.category_id).merge!(category_params))
  end
end
