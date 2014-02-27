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
      path = "/ticket_fields/#{id}.json"

      if body = self.data[:ticket_fields][id]
        response(
          :path => path,
          :body => {
            "ticket_field" => body
          },
        )
      else
        response(
          :path   => path,
          :status => 404,
          :body => {"error" => "RecordNotFound", "description" => "Not found"},
        )
      end
    end
  end # Mock
end
