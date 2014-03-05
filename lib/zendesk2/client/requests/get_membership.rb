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

      if body = self.data[:memberships][membership_id]
        response(
          :path => path,
          :body => {
            "organization_membership" => body
          },
        )
      else
        response(
          :path   => path,
          :status => 404,
          :body => {"error" => "RecordNotFound", "description" => "Not found"},
        )
      end
    end
  end # Mock
end
