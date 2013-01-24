class Zendesk2::Client
  class Real
    def destroy_request(params={})
      id = params["id"]

      request(
        :method => :delete,
        :path   => "/requests/#{id}.json"
      )
    end
  end

  class Mock
    def destroy_request(params={})
      id   = params["id"]
      body = self.data[:requests].delete(id)

      response(
        :method => :delete,
        :path   => "/requests/#{id}.json",
        :body   => {
          "request" => body,
        },
      )
    end
  end
end
