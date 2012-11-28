class Zendesk2::Client
  class Real
    def update_user(params={})
      id = params.delete("id")

      request(
        :method => :put,
        :path   => "/users/#{id}.json",
        :body   => {
          "user" => params
        },
      )
    end
  end
  class Mock
    def update_user(params={})
      id   = params.delete("id")
      path = "/users/#{id}.json"
      if params["email"] && self.data[:users].find{|k,u| u["email"] == params["email"] && k != id}
        response(
          :method => :put,
          :path   => path,
          :status => 422,
          :body   => {
            "error"       => "RecordInvalid",
            "description" => "Record validation errors", "details" => {
            "email"       => [ {
                "description" => "Email: #{params["email"]} is already being used by another user"
              } ]
            }
          }
        )
      else
        body = self.data[:users][id].merge!(params)
        response(
          :method => :put,
          :path   => path,
          :body   => {
            "user" => body
          },
        )
      end
    end
  end
end
