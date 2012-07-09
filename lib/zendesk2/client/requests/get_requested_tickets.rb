class Zendesk2::Client
  class Real
    def get_requested_tickets(params={})
      id          = params["id"]
      page_params = Zendesk2.paging_parameters(params)

      request(
        :params  => page_params,
        :method  => :get,
        :path    => "/users/#{id}/tickets/requested.json",
      )
    end
  end # Real

  class Mock
    def get_requested_tickets(params={})
      id = params["id"]

      page(params, :tickets, "/requesteds/#{id}/tickets.json", "tickets", filter: lambda{|c| c.select{|u| u["requester_id"] == id}})
    end
  end # Mock
end
