class Zendesk2::Client
  class Real
    def create_account(params={})
      request(
        :body   => {"account" => params},
        :method => :post,
        :path   => "/accounts.json",
      )
    end
  end # Real

  class Mock
    def create_account(params={})
      identity = self.class.new_id

      record = {
        "id"         => identity,
        "url"        => url_for("/accounts/#{identity}.json"),
        "created_at" => Time.now.iso8601,
        "updated_at" => Time.now.iso8601,
      }.merge(params)

      self.data[:accounts][identity]= record

      response(
        :method => :post,
        :body   => {"account" => record},
        :path   => "/accounts.json"
      )
    end
  end # Mock
end
