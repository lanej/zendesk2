class Zendesk2::Client
  class Real
    def get_forum(params={})
      id = params["id"]

      request(
        :method => :get,
        :path => "/forums/#{id}.json"
      )
    end
  end # Real

  class Mock
    def get_forum(params={})
      id   = params["id"]
      body = self.data[:forums][id]

      response(
        :path  => "/forums/#{id}.json",
        :body  => {
          "forum" => body
        },
      )
    end
  end # Mock
end
