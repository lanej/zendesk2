class Zendesk2
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

      response(
        :path => "/tickets_metrics/#{id}.json",
        :body => {
          "ticket_metric" => find!(:ticket_metrics, id)
        },
      )
    end
  end # Mock
end
