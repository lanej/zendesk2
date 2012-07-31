class Zendesk2::Client
  class Real
    def update_topic(params={})
      id = params.delete("id")

      request(
        :method => :put,
        :path   => "/topics/#{id}.json",
        :body   => {
          "topic" => params
        },
      )
    end
  end
  class Mock
    def update_topic(params={})
      id   = params.delete("id")
      path = "/topics/#{id}.json"

      body = self.data[:topics][id].merge!(params)
      response(
        :method => :put,
        :path   => path,
        :body   => {
          "topic" => body
        },
      )
    end
  end
end
