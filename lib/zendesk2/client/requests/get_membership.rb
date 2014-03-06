class Zendesk2::Client
  class Real
    def get_membership(params={})
      id = params["id"]

      request(
        :method => :get,
        :path   => "/organization_memberships/#{id}.json",
      )
    end
  end # Real

  class Mock
    def get_membership(params={})
      membership_id = params["id"]

      path = "/organization_memberships/#{membership_id}.json"

      response(
        :path => path,
        :body => {
          "organization_membership" => find!(:memberships, membership_id)
        },
      )
    end
  end # Mock
end
