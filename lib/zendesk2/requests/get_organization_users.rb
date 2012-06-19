class Zendesk2::Client
  class Real
    def get_organization_users(params={})
      id          = params["id"]
      page_params = Zendesk2.paging_parameters(params)

      request(
        :params  => page_params,
        :method  => :get,
        :path    => "/organizations/#{id}/users.json",
      )
    end
  end # Real

  class Mock
    def get_organization_users(params={})
      id = params["id"]
      page(params, :users, "/organizations/#{id}/users.json", "users", filter: lambda{|c| c.select{|u| u["organization_id"] == id}})
    end
  end # Mock
end
