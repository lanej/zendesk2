class Zendesk2::Client
  class Real
    def search(query, params={})
      request(
        :method => :get,
        :params => {query: query}.merge(params),
        :path   => "/search.json",
      )
    end
  end # Real

  class Mock
    def search(query, params={})
      terms = Hash[query.split(" ").map { |t| t.split(":") }]
      type = terms.delete("type")
      collection = type.nil? ? self.data.values : self.data[pluralize(type).to_sym]

      results = collection.values.select { |v| terms.all?{ |term, condition| v[term.to_s].to_s == condition.to_s } }

      page(params, nil, "/search.json", "results", resources: results, query: {query: query})
    end
  end # Mock
end
