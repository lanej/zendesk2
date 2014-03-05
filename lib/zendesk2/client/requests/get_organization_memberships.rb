class Zendesk2::Client
  class Real
    def get_organization_memberships(params={})
      organization_id = params["organization_id"]

      request(
        :method  => :get,
        :path    => "/organizations/#{organization_id}/memberships.json",
      )
    end
  end # Real

  class Mock
    def get_organization_memberships(params={})
      organization_id = params["organization_id"]

      page(params, :memberships, "/organizations/#{organization_id}/memberships.json", "organization_memberships", filter: lambda { |c| c.select { |m| m["organization_id"] == organization_id } })
    end
  end # Mock
end
