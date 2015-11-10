class Zendesk2
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
      id = params["id"]

      response(
        :path => "/ticket_audits/#{id}.json",
        :body => {
          "ticket_audit" => find!(:ticket_audits, id)
        },
      )
    end
  end # Mock
end
