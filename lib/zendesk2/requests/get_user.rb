class Zendesk2::Client
  class Real
    def get_user(params={})
      id = params["id"]

      request(
        :method => :get,
        :path => "/users/#{id}.json"
      )
    end
  end # Real

  class Mock
    def get_user(params={})
      id   = params["id"]
      body = self.data[:users][id]

      response(
        :path  => "/users/#{id}.json",
        :body  => {
          "user" => body
        },
      )
    end
  end # Mock
end
