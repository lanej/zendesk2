# frozen_string_literal: true
class Zendesk2::UpdateHelpCenterArticle
  include Zendesk2::Request

  request_method :put
  request_body { |r| { 'article' => r.article_params } }
  request_path do |r|
    locale = r.article_params['locale']
    locale ? "/help_center/#{locale}/articles/#{r.article_id}.json" : "/help_center/articles/#{r.article_id}.json"
  end

  def article_params
    Cistern::Hash.slice(params.fetch('article'), *Zendesk2::CreateHelpCenterArticle.accepted_attributes)
  end

  def article_id
    params.fetch('article').fetch('id')
  end

  def mock
    mock_response('article' => find!(:help_center_articles, article_id).merge!(article_params))
  end
end
