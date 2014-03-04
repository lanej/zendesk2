class Zendesk2::Client
  class Real
    def destroy_membership(params={})
      id = params["id"]

      request(
        :method => :delete,
        :path   => "/memberships/#{id}.json"
      )
    end
  end

  class Mock
    def destroy_membership(params={})
      id   = params["id"]

      body = self.data[:memberships].delete(id)
      response(
        :method => :delete,
        :path   => path,
        :body   => {
          "membership" => body,
        },
      )
    end
  end
end
