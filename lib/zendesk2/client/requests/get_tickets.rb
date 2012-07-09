class Zendesk2::Client
  class Real
    def get_tickets(params={})
      page_params = Zendesk2.paging_parameters(params)

      request(
        :params  => page_params,
        :method  => :get,
        :path    => "/tickets.json",
      )
    end
  end
  class Mock
    def get_tickets(params={})
      page(params, :tickets, "/tickets.json", "tickets")
    end
  end
end
