class Zendesk2::UpdateHelpCenterArticle < Zendesk2::Request
  request_method :put
  request_body { |r| { "article" => r.article_params } }
  request_path { |r|
    if locale = r.article_params["locale"]
      "/help_center/#{locale}/articles/#{r.article_id}.json"
    else
      "/help_center/articles/#{r.article_id}.json"
    end
  }

  def article_params
    @_article_params ||= Cistern::Hash.slice(params.fetch("article"), *Zendesk2::CreateHelpCenterArticle.accepted_attributes)
  end

  def article_id
    params.fetch("article").fetch("id")
  end

  def mock
    mock_response("article" => self.find!(:help_center_articles, article_id).merge!(article_params))
  end
end
