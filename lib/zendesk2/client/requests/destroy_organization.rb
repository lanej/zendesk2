class Zendesk2::Client
  class Real
    def destroy_organization(params={})
      id = params["id"]

      request(
        :method => :delete,
        :path   => "/organizations/#{id}.json"
      )
    end
  end

  class Mock
    def destroy_organization(params={})
      id   = params["id"]
      body = self.data[:organizations].delete(id)

      response(
        :method => :delete,
        :path   => "/organizations/#{id}.json",
        :body   => {
          "organization" => body,
        },
      )
    end
  end
end
