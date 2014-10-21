class Zendesk2::Client::DestroyHelpCenterCategory < Zendesk2::Client::Request
  request_path { |r| "/help_center/categories/#{r.category_id}.json" }
  request_method :delete

  def category_id
    params.fetch("category").fetch("id")
  end

  def mock
    mock_response("category" => self.delete!(:help_center_categories, category_id))
  end
end
