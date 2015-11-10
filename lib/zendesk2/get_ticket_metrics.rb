class Zendesk2
  class Real
    def get_ticket_metrics(params={})
      page_params = Zendesk2.paging_parameters(params)

      request(
        :params => page_params,
        :method => :get,
        :path   => "/ticket_metrics.json",
      )
    end
  end # Real

  class Mock
    def get_ticket_metrics(params={})
      page(params,
           :ticket_metrics,
           "/ticket_metrics.json",
           "metrics")
    end
  end
end
