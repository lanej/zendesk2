class Zendesk2::Client
  class Real
    def create_user(params={})
      request(
        :body   => {"user" => params},
        :method => :post,
        :path   => "/users.json",
      )
    end
  end # Real

  class Mock
    def create_user(params={})
      identity = self.class.new_id

      record = {
        "id"         => identity,
        "url"        => url_for("/users/#{identity}.json"),
        "created_at" => Time.now.iso8601,
        "updated_at" => Time.now.iso8601,
      }.merge(params)

      self.data[:users][identity]= record

      response(
        :method => :post,
        :body   => {"user" => record},
        :path   => "/users.json"
      )
    end
  end # Mock
end
