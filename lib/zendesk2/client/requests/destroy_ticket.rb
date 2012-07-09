class Zendesk2::Client
  class Real
    def destroy_ticket(params={})
      id = params["id"]

      request(
        :method => :delete,
        :path   => "/tickets/#{id}.json"
      )
    end
  end

  class Mock
    def destroy_ticket(params={})
      id   = params["id"]
      body = self.data[:tickets].delete(id)

      response(
        :method => :delete,
        :path   => "/tickets/#{id}.json",
        :body   => {
          "ticket" => body,
        },
      )
    end
  end
end
