class Zendesk2::Client
  class Real
    alias search_user search
  end # Real

  class Mock
    def search_user(query)
      terms = Hash[query.split(" ").map { |t| t.split(":") }]
      terms.delete("type") # context already provided

      collection = self.data[:users].values
      collection = collection.map do |user|
        self.data[:identities].values.select{|i| i["type"] == "email" && i["user_id"] == user["id"]}.map do |identity|
          user.merge("email" => identity["value"])
        end
      end.flatten

      results = collection.select { |v| terms.all?{ |term, condition| v[term.to_s].to_s == condition.to_s } }

      response(
        :path => "/search.json",
        :body => {"results" => results},
      )
    end
  end # Mock
end
