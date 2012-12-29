class Zendesk2::Client
  class Real
    def create_group(params={})
      request(
        :body   => {"group" => params},
        :method => :post,
        :path   => "/groups.json",
      )
    end
  end # Real

  class Mock
    def create_group(params={})
      identity = self.class.new_id

      record = {
        "id"               => identity,
        "url"              => url_for("/groups/#{identity}.json"),
        "created_at"       => Time.now.iso8601,
        "updated_at"       => Time.now.iso8601,
        "deleted"          => false,
      }.merge(params)

      self.data[:groups][identity] = record

      response(
        :method => :post,
        :body   => {"group" => record},
        :path   => "/groups.json"
      )
    end
  end # Mock
end # Zendesk2::Client
