class Zendesk2::Client
  class Real
    def create_ticket(params={})
      request(
        :body   => {"ticket" => params},
        :method => :post,
        :path   => "/tickets.json",
      )
    end
  end # Real

  class Mock
    def create_ticket(params={})
      identity = self.class.new_id

      record = {
        "id"         => identity,
        "url"        => url_for("/tickets/#{identity}.json"),
        "created_at" => Time.now.iso8601,
        "updated_at" => Time.now.iso8601,
      }.merge(params)

      self.data[:tickets][identity]= record

      response(
        :method => :post,
        :body   => {"ticket" => record},
        :path   => "/tickets.json"
      )
    end
  end # Mock
end
