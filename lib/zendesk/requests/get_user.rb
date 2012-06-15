class Zendesk::Client
  class Real
    def get_user(params={})
      id = params["id"]

      request(
        :method => :get,
        :path => "/users/#{id}.json"
      )
    end
  end
  class Mock
    def get_user(params={})
      id = params["id"]

      body = self.data[:users][id]
      Faraday::Response.new(
        :method          => :get,
        :status          => 200,
        :url             => url,
        :body            => {"user" => body},
        :request_headers => {
          "Content-Type"   => "application/json"
        },
      )
    end
  end
end
