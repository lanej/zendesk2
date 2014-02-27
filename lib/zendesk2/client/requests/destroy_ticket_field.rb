class Zendesk2::Client
  class Real
    def destroy_ticket_field(params={})
      id = params["id"]

      request(
        :method => :delete,
        :path   => "/ticket_fields/#{id}.json"
      )
    end
  end

  class Mock
    def destroy_ticket_field(params={})
      id   = params["id"]
      body = self.data[:ticket_fields].delete(id)

      response(
        :method => :delete,
        :path   => "/ticket_fields/#{id}.json",
        :body   => {
          "ticket_field" => body,
        },
      )
    end
  end
end
