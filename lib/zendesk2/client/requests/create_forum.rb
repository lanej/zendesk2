class Zendesk2::Client
  class Real
    def create_forum(params={})
      request(
        :body   => {"forum" => params},
        :method => :post,
        :path   => "/forums.json",
      )
    end
  end # Real

  class Mock
    def create_forum(params={})
      identity = self.class.new_id

      record = {
        "id"         => identity,
        "url"        => url_for("/forums/#{identity}.json"),
        "created_at" => Time.now.iso8601,
        "updated_at" => Time.now.iso8601,
      }.merge(params)

      path = "/forums.json"
      self.data[:forums][identity]= record

      response(
        :method => :post,
        :body   => {"forum" => record},
        :path   => path,
      )
    end
  end # Mock
end
