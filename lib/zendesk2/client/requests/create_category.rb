class Zendesk2::Client
  class Real
    def create_category(params={})
      request(
        :body   => {"category" => params},
        :method => :post,
        :path   => "/categories.json",
      )
    end
  end # Real

  class Mock
    def create_category(params={})
      identity = self.class.new_id

      record = {
        "id"         => identity,
        "url"        => url_for("/categories/#{identity}.json"),
        "created_at" => Time.now.iso8601,
        "updated_at" => Time.now.iso8601,
      }.merge(params)

      self.data[:categories][identity]= record

      response(
        :method => :post,
        :body   => {"category" => record},
        :path   => "/categories.json"
      )
    end
  end # Mock
end
