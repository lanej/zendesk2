class Zendesk2::Client
  class Real
    def update_organization(params={})
      id = params.delete("id")

      request(
        :method => :put,
        :path   => "/organizations/#{id}.json",
        :body   => {
          "organization" => params
        },
      )
    end
  end
  class Mock
    def update_organization(params={})
      id = params.delete("id")

      organization = self.find!(:organizations, id)

      if self.data[:organizations].values.find { |o| o["name"] == params["name"] && o["id"] != id }
        error!(:invalid, details: {"name" => [ { "description" => "Name: has already been taken" } ]})
      end

      body = organization.merge!(params)

      response(
        :method => :put,
        :path   => "/organizations/#{id}.json",
        :body   => {
          "organization" => body
        },
      )
    end
  end
end
