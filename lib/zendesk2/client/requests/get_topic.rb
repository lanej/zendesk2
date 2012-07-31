class Zendesk2::Client
  class Real
    def get_topic(params={})
      id = params["id"]

      request(
        :method => :get,
        :path => "/topics/#{id}.json"
      )
    end
  end # Real

  class Mock
    def get_topic(params={})
      id   = params["id"]
      body = self.data[:topics][id]

      response(
        :path  => "/topics/#{id}.json",
        :body  => {
          "topic" => body
        },
      )
    end
  end # Mock
end
