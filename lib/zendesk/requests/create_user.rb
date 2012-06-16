class Zendesk::Client
  class Real
    def create_user(params={})
      request(
        :body => {"user" => params},
        :method => :post,
        :path => "/users.json",
      )
    end
  end # Real
  class Mock
    def create_user(params={})
      identity = self.class.new_id

      record = {
        "id"         => identity,
        "url"        => File.join(@url, "/users/#{identity}.json"),
        "created_at" => Time.now.iso8601,
        "updated_at" => Time.now.iso8601,
      }.merge(params)

      self.data[:users][identity]= record

      Faraday::Response.new(
        :method          => :get,
        :status          => 200,
        :url             => url,
        :body            => {"user" => record},
        :request_headers => {
          "Content-Type"   => "application/json"
        },
      )
    end
  end # Mock
end
