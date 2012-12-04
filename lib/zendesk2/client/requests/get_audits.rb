class Zendesk2::Client
  class Real
    def get_audits(params={})
      id          = params["ticket_id"]
      page_params = Zendesk2.paging_parameters(params)

      request(
        :params  => page_params,
        :method  => :get,
        :path    => "/tickets/#{id}/audits.json",
      )
    end
  end # Real

  class Mock
    def get_audits(params={})
      id = params["ticket_id"]
      filter = lambda { |audit| audit.select{|a| a['ticket_id'] == id } }

      page(params, :ticket_audits, "/tickets/#{id}/audits.json", "audits", filter: filter)
    end
  end # Mock
end
