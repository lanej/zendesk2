class Zendesk2::Client
  class Real
    def create_request(params={})
      request(
        :body   => {"request" => params},
        :method => :post,
        :path   => "/requests.json",
      )
    end
  end # Real

  class Mock
    def create_request(params={})
      identity = self.class.new_id

      record = {
        "id"         => identity,
        "url"        => url_for("/requests/#{identity}.json"),
        "created_at" => Time.now.iso8601,
        "updated_at" => Time.now.iso8601,
      }.merge(params)

      record["requester_id"] ||= current_user["id"]

      # FIXME: throw error if user doesn't exist?
      requester = self.data[:users][record["requester_id"]]

      self.data[:requests][identity] = record

      response(
        :method => :post,
        :body   => {"request" => record},
        :path   => "/requests.json"
      )
    end
  end # Mock
end # Zendesk2::Client
