class Zendesk2::SearchUser < Zendesk2::Request
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

    collection = self.data[:users].values

    # create a copy of each user mapped to a specific user identity
    collection = collection.map do |user|
      self.data[:identities].values.select { |i| i["type"] == "email" && i["user_id"] == user["id"] }.map do |identity|
        user.merge("email" => identity["value"])
      end
    end.flatten

    # allow searching by organization name
    collection = collection.map do |user|
      if organization = self.data[:organizations][user["organization_id"].to_i]
        user.merge("organization" => organization["name"])
      else
        user
      end
    end

    # organization name is fuzzy matched
    if organization_name = terms.delete("organization")
      terms.merge!("organization" => "*#{organization_name}*")
    end

    compiled_terms = terms.inject({}) do |r,(term, raw_condition)|
      condition = if raw_condition.include?("*")
                    Regexp.compile(raw_condition.gsub("*", ".*"), Regexp::IGNORECASE)
                  else
                    raw_condition
                  end
      r.merge(term => condition)
    end

    munged_results = collection.select do |v|
      compiled_terms.all? do |term, condition|
        condition.is_a?(Regexp) ? condition.match(v[term.to_s]) : v[term.to_s].to_s == condition.to_s
      end
    end

    # return the unmunged data
    results = munged_results.map { |u|
      identities = self.data[:identities].values.select { |i| i["user_id"] == u["id"] }

      if identity = identities.find { |i| i["type"] == "email" && i["primary"] } || identities.find { |i| i["type"] == "email" }
        u.merge!("email" => identity["value"])
      end
    }

    page(results, params: {"query" => query}, root: "results")
  end
end
