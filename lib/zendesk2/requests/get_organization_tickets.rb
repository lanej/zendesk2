class Zendesk2::Client
  class Real
    def get_organization_tickets(params={})
      id          = params["id"]
      page_params = Zendesk2.paging_parameters(params)

      request(
        :params  => page_params,
        :method  => :get,
        :path    => "/organizations/#{id}/tickets.json",
      )
    end
  end # Real

  class Mock
    def get_organization_tickets(params={})
      id = params["id"]

      page(params, :tickets, "/organizations/#{id}/tickets.json", "tickets", filter: lambda{|c| c.select{|u| u["organization_id"].to_s == id.to_s}})
    end
  end # Mock
end
