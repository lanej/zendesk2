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
      body = self.data[:users][id].merge!(params)

      response(
        :method => :put,
        :path   => "/users/#{id}.json",
        :body   => {
          "user" => body
        },
      )
    end
  end
end
