class Zendesk2::Client
  class Real
    def get_ticket_field(params={})
      id = params["id"]

      request(
        :method => :get,
        :path => "/ticket_fields/#{id}.json"
      )
    end
  end # Real

  class Mock
    def get_ticket_field(params={})
      id   = params["id"]

      response(
        :path => "/ticket_fields/#{id}.json",
        :body => {
          "ticket_field" => find!(:ticket_fields, id)
        },
      )
    end
  end # Mock
end
