class Zendesk2::Client
  class Real
    def create_topic(params={})
      request(
        :body   => {"topic" => params},
        :method => :post,
        :path   => "/topics.json",
      )
    end
  end # Real

  class Mock
    def create_topic(params={})
      identity = self.class.new_id

      record = {
        "id"         => identity,
        "url"        => url_for("/topics/#{identity}.json"),
        "created_at" => Time.now.iso8601,
        "updated_at" => Time.now.iso8601,
      }.merge(params)

      path = "/topics.json"
      self.data[:topics][identity]= record

      response(
        :method => :post,
        :body   => {"topic" => record},
        :path   => path,
      )
    end
  end # Mock
end
