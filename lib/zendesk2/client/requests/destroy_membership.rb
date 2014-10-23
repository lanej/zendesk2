class Zendesk2::Client
  class Real
    def destroy_membership(params={})
      id = params["id"]

      request(
        :method => :delete,
        :path   => "/organization_memberships/#{id}.json"
      )
    end
  end

  class Mock
    def destroy_membership(params={})
      id   = params["id"]

      body = self.delete!(:memberships, id)

      response(
        :method => :delete,
        :path   => "/organization_memberships/#{id}.json",
        :body   => {
          "membership" => body,
        },
      )
    end
  end
end
