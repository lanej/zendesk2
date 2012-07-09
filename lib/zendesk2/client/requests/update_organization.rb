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
      id   = params.delete("id")
      body = self.data[:organizations][id].merge!(params)

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
