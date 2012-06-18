class Zendesk2::Client
  class Real
    def update_ticket(params={})
      id = params.delete("id")

      request(
        :method => :put,
        :path   => "/tickets/#{id}.json",
        :body   => {
          "ticket" => params
        },
      )
    end
  end
  class Mock
    def update_ticket(params={})
      id   = params.delete("id")
      body = self.data[:tickets][id].merge!(params)

      response(
        :method => :put,
        :path   => "/tickets/#{id}.json",
        :body   => {
          "ticket" => body
        },
      )
    end
  end
end
