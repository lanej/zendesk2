class Zendesk2::Client
  class Real
    def destroy_user(params={})
      id = params["id"]

      request(
        :method => :delete,
        :path => "/users/#{id}.json"
      )
    end
  end
  class Mock
    def destroy_user(params={})
      id   = params["id"]
      url  = File.join(@url, "/users/#{id}.json")
      body = self.data[:users].delete(id)

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
