class Zendesk2::SearchOrganization < Zendesk2::Request
  request_method :get
  request_path { "/search.json" }
  request_body { |r| { "query" => r.query } }

  attr_reader :query

  page_params!

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

    page(results, params: {"query" => query}, root: "results")
  end
end
