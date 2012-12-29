class Zendesk2::Client
  class Real
    def get_groups(params={})
      page_params = Zendesk2.paging_parameters(params)

      request(
        :params  => page_params,
        :method  => :get,
        :path    => "/groups.json",
      )
    end
  end
  class Mock
    def get_groups(params={})
      page(params, :groups, "/groups.json", "groups")
    end
  end
end
