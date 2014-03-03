class Zendesk2::Client
  class Real
    def create_membership(params={})
      user_id     = params["user_id"]

      request(
        :body   => {"organization_membership" => params },
        :method => :post,
        :path   => "/users/#{user_id}/organization_memberships.json",
      )
    end
  end # Real

  class Mock
    def create_membership(params={})
      user_id         = params["user_id"]
      organization_id = params["organization_id"]

      raise NotImplementedError
    end
  end # Mock
end
