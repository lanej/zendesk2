class Zendesk2::Client
  class Real
    alias search_user search
  end # Real

  class Mock
    def search_user(query)
      terms = Hash[query.split(" ").map { |t| t.split(":") }]
      terms.delete("type") # context already provided

      collection = self.data[:users].values

      # create a copy of each user mapped to a specific user identity
      collection = collection.map do |user|
        self.data[:identities].values.select{|i| i["type"] == "email" && i["user_id"] == user["id"]}.map do |identity|
          user.merge("email" => identity["value"])
        end
      end.flatten

      # allow searching by organization name
      collection = collection.map do |user|
        if organization = self.data[:organizations][user["organization_id"]]
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

      results = collection.select do |v|
        compiled_terms.all? do |term, condition|
          condition.is_a?(Regexp) ? condition.match(v[term.to_s]) : v[term.to_s].to_s == condition.to_s
        end
      end

      response(
        :path => "/search.json",
        :body => {"results" => results},
      )
    end
  end # Mock
end
