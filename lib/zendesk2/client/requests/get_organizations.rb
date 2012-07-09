class Zendesk2::Client
  class Real
    def get_organizations(params={})
      page_params = Zendesk2.paging_parameters(params)

      request(
        :params  => page_params,
        :method  => :get,
        :path    => "/organizations.json",
      )
    end
  end
  class Mock
    def get_organizations(params={})
      page(params, :organizations, "/organizations.json", "organizations")
    end
  end
end
