# frozen_string_literal: true
class Zendesk2::SearchHelpCenterArticles
  include Zendesk2::Request

  request_path { |_| '/help_center/articles/search.json' }

  attr_reader :query

  def call(query, params)
    @query = query
    super(params)
  end

  def mock
    terms = Hash[query.split(' ').map { |t| t.split(':') }]

    collection = data[:help_center_articles].values

    results = collection.select { |v| terms.all? { |term, condition| v[term.to_s].to_s == condition.to_s } }

    page(results, params: { 'query' => query }, root: 'results')
  end
end
