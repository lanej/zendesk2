# frozen_string_literal: true
class Zendesk2::GetHelpCenterArticle
  include Zendesk2::Request

  request_path do |r|
    locale = r.params.fetch('article')['locale']
    locale ? "/help_center/#{locale}/articles/#{r.article_id}.json" : "/help_center/articles/#{r.article_id}.json"
  end

  def article_id
    params.fetch('article').fetch('id')
  end

  def mock
    mock_response('article' => find!(:help_center_articles, article_id))
  end
end
