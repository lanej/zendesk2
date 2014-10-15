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
    def update_organization(_params={})
      params = Cistern::Hash.stringify_keys(_params)
      id     = params.delete("id")

      organization = self.find!(:organizations, id)

      other_organizations = self.data[:organizations].dup
      other_organizations.delete(id)

      if other_organizations.values.find { |o| o["name"] == params["name"] }
        error!(:invalid, details: {"name" => [ { "description" => "Name: has already been taken" } ]})
      end

      if params["external_id"] && other_organizations.values.find { |o| o["external_id"] == params["external_id"] }
        error!(:invalid, details: {"name" => [ { "description" => "External has already been taken" } ]})
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
