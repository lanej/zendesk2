class Zendesk2::Client
  class Real
    def search(query)
      term = query.map{|k,v| "#{k}:#{v}"}.join(" ")
      request(
        :method => :get,
        :params => {query: term},
        :path   => "/search.json",
      )
    end
  end # Real

  class Mock
    def search(query)
      type       = query.delete("type")
      collection = type.nil? ? self.data.values : self.data[pluralize(type).to_sym]

      results = collection.select{|k,v| query.all?{|term, condition| v[term.to_s] == condition}}.values

      response(
        :path => "/search.json",
        :body => {"results" => results},
      )
    end
  end # Mock
end
