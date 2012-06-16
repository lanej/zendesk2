class Zendesk::Client
  class Real
    def get_users(params={})
      request(
        :params => params,
        :method => :get,
        :path => "/users.json"
      )
    end
  end
  class Mock
    def get_users(params={})
      page_size  = (params["per_page"] || 50).to_i
      page_index = (params["page"] || 1).to_i
      count      = self.data[:users].size

      url    = File.join(@url, "/users.json")
      offset = (page_index - 1) * page_size
      body   = self.data[:users].values.slice(offset, page_size)

      Faraday::Response.new(
        :method          => :get,
        :status          => 200,
        :url             => url,
        :body            => {"users" => body},
        :request_headers => {
          "Content-Type"   => "application/json"
        },
      )
    end
  end
end
