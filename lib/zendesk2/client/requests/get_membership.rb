class Zendesk2::Client
  class Real
    def get_membership(params={})
      user_id         = params["id"]
      organization_id = params["id"]
      page_params = Zendesk2.paging_parameters(params)

      request(
        :params  => page_params,
        :method  => :get,
        :path    => "/users/#{user_id}/organizations_memberships/#{organization_id}.json",
      )
    end
  end # Real

  class Mock
    def get_membership(params={})
      user_id         = params["id"]
      organization_id = params["id"]

      page(params, :memberships, "/organizations/#{id}/memberships.json", "organization_memberships", filter: lambda{|c| c.select { |a| a["user_id"] == user_id && a["organization_id"] == organization_id }})
    end
  end # Mock
end
