class Zendesk2::Client
  class Real
    def search_help_center_articles(query)
      request(
        :method => :get,
        :params => {query: query},
        :path   => "/help_center/articles/search.json",
      )
    end
  end # Real

  class Mock
    def search_help_center_articles(query)
      terms = Hash[query.split(" ").map { |t| t.split(":") }]

      collection = self.data[:help_center_articles].values

      results = collection.select { |v| terms.all?{ |term, condition| v[term.to_s].to_s == condition.to_s } }

      response(
        :path => "/search.json",
        :body => {"results" => results},
      )
    end
  end # Mock
end
