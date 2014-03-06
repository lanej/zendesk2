class Zendesk2::Client
  class Real
    def get_organization(params={})
      id = params["id"]

      request(
        :method => :get,
        :path   => "/organizations/#{id}.json"
      )
    end
  end # Real

  class Mock
    def get_organization(params={})
      id = params["id"]

      response(
        :path  => "/organizations/#{id}.json",
        :body  => {
          "organization" => find!(:organizations, id)
        },
      )
    end
  end # Mock
end
