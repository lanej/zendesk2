class Zendesk2::GetHelpCenterArticle < Zendesk2::Request
  request_path { |r|
    if locale = r.params.fetch("article")["locale"]
      "/help_center/#{locale}/articles/#{r.article_id}.json"
    else
      "/help_center/articles/#{r.article_id}.json"
    end
  }

  def article_id
    params.fetch("article").fetch("id")
  end

  def mock
    mock_response("article" => self.find!(:help_center_articles, article_id))
  end
end
