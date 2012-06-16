class Zendesk::Client
  class Real
    def update_user(params={})
      id = params.delete("id")

      request(
        :body   => {"user" => params},
        :method => :put,
        :path   => "/users/#{id}.json"
      )
    end
  end
  class Mock
    def update_user(params={})
      id   = params.delete("id")
      url  = File.join(@url, "/users/#{id}.json")
      body = self.data[:users][id].merge!(params)

      Faraday::Response.new(
        :method          => :delete,
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
