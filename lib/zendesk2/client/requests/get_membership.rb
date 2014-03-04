class Zendesk2::Client
  class Real
    def get_membership(params={})
      user_id         = params["user_id"]
      organization_id = params["organization_id"]
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
      user_id         = params["user_id"]
      organization_id = params["organization_id"]

      page(params, :memberships, "/users/#{user_id}/organization_memberships/#{organization_id}.json", "organization_memberships", filter: lambda{|c| c.select { |a| a["user_id"] == user_id.to_i && a["organization_id"] == organization_id.to_i }})
    end
  end # Mock
end
