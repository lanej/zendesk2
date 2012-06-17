class Zendesk2::Client
  class Real
    def get_current_user
      request(
        :method => :get,
        :path => "/users/me.json",
      )
    end
  end # Real
  class Mock
    def get_current_user

      body = self.data[:users][@current_user_id]
      url = File.join(@url, "/users/me.json")

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
  end # Mock
end
