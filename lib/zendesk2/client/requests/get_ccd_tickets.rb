class Zendesk2::Client
  class Real
    def get_ccd_tickets(params={})
      id          = params["id"]
      page_params = Zendesk2.paging_parameters(params)

      request(
        :params  => page_params,
        :method  => :get,
        :path    => "/users/#{id}/tickets/ccd.json",
      )
    end
  end # Real

  class Mock
    def get_ccd_tickets(params={})
      id = params["id"]

      page(params, :tickets, "/users/#{id}/tickets/ccd.json", "tickets", filter: lambda{|c| c.select{|u| u["collaborator_ids"].include?(id)}})
    end
  end # Mock
end
