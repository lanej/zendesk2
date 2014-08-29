class Zendesk2::Client
  class Real
    def search(query)
      request(
        :method => :get,
        :params => {query: query},
        :path   => "/search.json",
      )
    end
  end # Real

  class Mock
    def search(query)
      terms = Hash[query.split(" ").map { |t| t.split(":") }]
      type = terms.delete("type")
      collection = type.nil? ? self.data.values : self.data[pluralize(type).to_sym]

      results = collection.values.select { |v| terms.all?{ |term, condition| v[term.to_s].to_s == condition.to_s } }

      response(
        :path => "/search.json",
        :body => {"results" => results},
      )
    end
  end # Mock
end
