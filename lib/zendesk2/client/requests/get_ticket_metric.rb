class Zendesk2::Client
  class Real
    def get_ticket_metric(params={})
      id        = params["id"]
      ticket_id = params["ticket_id"]
      if id
        request(
          :method => :get,
          :path => "/ticket_metrics/#{id}.json"
        )
      else
        request(
          :method => :get,
          :path => "/tickets/#{ticket_id}/metrics.json"
        )
      end
    end
  end # Real

  class Mock
    def get_ticket_metric(params={})
      id        = params["id"]
      ticket_id = params["ticket_id"]

      path = "/tickets_metrics/#{id}.json"

      if body = self.data[:ticket_metrics][id]
        response(
          :path => path,
          :body => {
            "ticket_metric" => body
          },
        )
      else
        response(
          :path   => path,
          :status => 404,
          :body   => {"error" => "RecordNotFound", "description" => "Not found"},
        )
      end
    end
  end # Mock
end
