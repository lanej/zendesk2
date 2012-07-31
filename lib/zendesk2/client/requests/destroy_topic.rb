class Zendesk2::Client
  class Real
    def destroy_topic(params={})
      id = params["id"]

      request(
        :method => :delete,
        :path   => "/topics/#{id}.json"
      )
    end
  end

  class Mock
    def destroy_topic(params={})
      id   = params["id"]
      path = "/topics/#{id}.json"

      body = self.data[:topics].delete(id)
      response(
        :method => :delete,
        :path   => path,
        :body   => {
          "topic" => body,
        },
      )
    end
  end
end
