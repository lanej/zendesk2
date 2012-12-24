class Zendesk2::Client
  class Real
    def get_ticket_audits(params={})
      ticket_id   = params["ticket_id"]
      page_params = Zendesk2.paging_parameters(params)

      request(
        :params  => page_params,
        :method  => :get,
        :path    => "/tickets/#{ticket_id}/audits.json",
      )
    end
  end # Real

  class Mock
    def get_ticket_audits(params={})
      ticket_id = params["ticket_id"]

      page(params, :ticket_audits, "/tickets/#{ticket_id}/audits.json", "audits", filter: lambda{|c| c.select{|a| a["ticket_id"] == ticket_id}})
    end
  end # Mock
end
