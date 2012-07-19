class Zendesk2::Client
  class Real
    def update_forum(params={})
      id = params.delete("id")

      request(
        :method => :put,
        :path   => "/forums/#{id}.json",
        :body   => {
          "forum" => params
        },
      )
    end
  end
  class Mock
    def update_forum(params={})
      id   = params.delete("id")
      path = "/forums/#{id}.json"

      body = self.data[:forums][id].merge!(params)
      response(
        :method => :put,
        :path   => path,
        :body   => {
          "forum" => body
        },
      )
    end
  end
end
