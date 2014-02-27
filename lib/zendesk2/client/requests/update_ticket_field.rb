class Zendesk2::Client
  class Real
    def update_ticket_field(params={})
      id = params.delete("id")

      request(
        :method => :put,
        :path   => "/ticket_fields/#{id}.json",
        :body   => {
          "ticket_field" => params
        },
      )
    end
  end
  class Mock
    def update_ticket_field(params={})
      ticket_field_id = params.delete("id")
      body            = self.data[:ticket_fields][ticket_field_id].merge!(params)

      response(
        :method => :put,
        :path   => "/ticket_fields/#{ticket_field_id}.json",
        :body   => {
          "ticket_field" => body
        },
      )
    end
  end
end
