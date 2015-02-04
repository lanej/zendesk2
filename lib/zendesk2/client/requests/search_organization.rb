class Zendesk2::Client
  class Real
    alias search_organization search
  end # Real

  class Mock
    def search_organization(query)
      terms = Hash[query.split(" ").map { |t| t.split(":") }]
      terms.delete("type") # context already provided

      collection = self.data[:organizations].values

      # organization name is fuzzy matched
      if organization_name = terms.delete("name")
        terms.merge!("name" => "*#{organization_name}*")
      end

      compiled_terms = terms.inject({}) do |r,(term, raw_condition)|
        condition = if raw_condition.include?("*")
                      Regexp.compile(raw_condition.gsub("*", ".*"), Regexp::IGNORECASE)
                    else
                      raw_condition
                    end
        r.merge(term => condition)
      end

      results = collection.select do |v|
        compiled_terms.all? do |term, condition|
          condition.is_a?(Regexp) ? condition.match(v[term.to_s]) : v[term.to_s].to_s == condition.to_s
        end
      end

      page({}, :organizations, "/search.json", "results", resources: results, query: {query: query})
    end
  end # Mock
end
