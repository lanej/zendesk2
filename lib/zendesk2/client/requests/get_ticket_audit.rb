class Zendesk2::Client
  class Real
    def get_ticket_audit(params={})
      id        = params["id"]
      ticket_id = params["ticket_id"]

      request(
        :method => :get,
        :path => "/tickets/#{ticket_id}/audits/#{id}.json"
      )
    end
  end # Real

  class Mock
    def get_ticket_audit(params={})
      id        = params["id"]
      ticket_id = params["ticket_id"]

      path = "/ticket_audits/#{id}.json"

      if body = self.data[:ticket_audits][id]
        response(
          :path => path,
          :body => {
            "ticket_audit" => body
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
