class Zendesk2::Client
  class Real
    def update_request(params={})
      id = params.delete("id")

      request(
        :method => :put,
        :path   => "/requests/#{id}.json",
        :body   => {
          "request" => params
        },
      )
    end
  end
  class Mock
    def update_request(params={})
      id   = params.delete("id")
      body = self.data[:tickets][id].merge!(params)

      response(
        :method => :put,
        :path   => "/tickets/#{id}.json",
        :body   => {
          "request" => body
        },
      )
    end
  end
end
