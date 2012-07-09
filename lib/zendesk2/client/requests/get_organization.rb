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
      id   = params["id"]
      if body = self.data[:organizations][id]

        response(
          :path  => "/organizations/#{id}.json",
          :body  => {
            "organization" => body
          },
        )
      else 
        response(
          :path   => "/organizations/#{id}.json",
          :status => 404
        )
      end
    end
  end # Mock
end
