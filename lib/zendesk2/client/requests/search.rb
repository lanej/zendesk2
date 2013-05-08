class Zendesk2::Client
  class Real
    def search(query, search_options = {})
      search_path = search_options[:path] || "/search.json"
      if search_options[:direct_query]
        params = query
      else
        term = query.map{|k,v| "#{k}:#{v}"}.join(" ")
        params = {query: "\"#{term}\""}
      end
      request(
        :method => :get,
        :params => params,
        :path   => search_path,
      )
    end
  end # Real

  class Mock
    def search(query, search_options = {})
      search_path = search_options[:search_path] || "/search.json"
      type       = query.delete("type")
      collection = type.nil? ? self.data.values : self.data[pluralize(type).to_sym]

      results = collection.select{|k,v| query.all?{|term, condition| v[term.to_s] == condition}}.values

      response(
        :path => search_path,
        :body => {(search_options[:results_collection_name] || "results") => results},
      )
    end
  end # Mock
end
