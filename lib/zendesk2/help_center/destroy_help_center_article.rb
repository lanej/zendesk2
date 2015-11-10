class Zendesk2::DestroyHelpCenterArticle < Zendesk2::Request
  request_method :delete
  request_path { |r| "/help_center/articles/#{r.article_id}.json" }

  def article_id
    params.fetch("article").fetch("id")
  end

  def mock
    mock_response("article" => self.find!(:help_center_articles, article_id))
  end
end
