class Zendesk2::Client
  class Real
    alias search_user search
  end # Real

  class Mock
    def search_user(query)
      query.delete("type") # context already provided

      collection = self.data[:users].values
      collection = collection.map do |user|
        self.data[:identities].values.select{|i| i["type"] == "email" && i["user_id"] == user["id"]}.map do |identity|
          user.merge("email" => identity["value"])
        end
      end.flatten

      results = collection.select{|v| query.all?{|term, condition| v[term.to_s] == condition}}

      response(
        :path => "/search.json",
        :body => {"results" => results},
      )
    end
  end # Mock
end
