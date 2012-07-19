class Zendesk2::Client
  class Real
    def destroy_forum(params={})
      id = params["id"]

      request(
        :method => :delete,
        :path   => "/forums/#{id}.json"
      )
    end
  end

  class Mock
    def destroy_forum(params={})
      id   = params["id"]
      path = "/forums/#{id}.json"

      body = self.data[:forums].delete(id)
      response(
        :method => :delete,
        :path   => path,
        :body   => {
          "forum" => body,
        },
      )
    end
  end
end
