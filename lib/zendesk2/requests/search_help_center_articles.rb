class Zendesk2::SearchHelpCenterArticles < Zendesk2::Request
  request_path { |_| "/help_center/articles/search.json" }

  attr_reader :query

  def _mock(query, params={})
    @query = query
    setup(params)
    mock
  end

  def _real(query, params={})
    @query = query
    setup(params)
    real
  end

  def mock
    terms = Hash[query.split(" ").map { |t| t.split(":") }]

    collection = self.data[:help_center_articles].values

    results = collection.select { |v| terms.all?{ |term, condition| v[term.to_s].to_s == condition.to_s } }

    page(results, params: {"query" => query}, root: "results")
  end
end
