class Zendesk2::Client
  class Real
    def create_user_identity(params={})
      user_id = params.delete("user_id")

      request(
        :body   => {"identity" => params},
        :method => :post,
        :path   => "/users/#{user_id}/identities.json",
      )
    end
  end # Real

  class Mock
    def create_user_identity(params={})
      identity = self.class.new_id
      user_id  = params["user_id"]

      record = {
        "id"         => identity,
        "url"        => url_for("/user/#{user_id}/identities/#{identity}.json"),
        "created_at" => Time.now.iso8601,
        "updated_at" => Time.now.iso8601,
        "verified"   => false,
        "primary"    => false,
      }.merge(params)

      record.merge("primary" => true) if self.data[:identities].values.find{|ui| ui["user_id"] == user_id}.nil?

      self.data[:identities][identity] = record

      response(
        :method => :post,
        :path   => "/user/#{user_id}/identities.json",
        :body   => {"identity" => record}
      )
    end
  end # Mock
end
