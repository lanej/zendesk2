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
      id = require_parameters(params, "id")
      body = self.delete!(:organizations, id)

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
