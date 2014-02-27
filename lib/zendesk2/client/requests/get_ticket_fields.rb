class Zendesk2::Client
  class Real
    def get_ticket_fields(params={})
      page_params = Zendesk2.paging_parameters(params)

      request(
        :params  => page_params,
        :method  => :get,
        :path    => "/ticket_fields.json",
      )
    end
  end
  class Mock
    def get_ticket_fields(params={})
      page(params, :ticket_fields, "/ticket_fields.json", "ticket_fields")
    end
  end
end
