class Zendesk2::Client
  class Real
    def search_help_center_articles(query, params={})
      request(
        :method => :get,
        :params => {query: query}.merge(params),
        :path   => "/help_center/articles/search.json",
      )
    end
  end # Real

  class Mock
    def search_help_center_articles(query, params={})
      terms = Hash[query.split(" ").map { |t| t.split(":") }]

      collection = self.data[:help_center_articles].values

      results = collection.select { |v| terms.all?{ |term, condition| v[term.to_s].to_s == condition.to_s } }

      page(params, :help_center_articles, "/search.json", "results", resources: results, query: {query: query})
    end
  end # Mock
end
