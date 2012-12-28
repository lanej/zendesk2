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
        "active"     => true,
      }.merge(params)

      path = "/users.json"
      if (email = record["email"]) && self.data[:users].find{|k,u| u["email"] == email && k != identity}
        response(
          :method => :put,
          :path   => path,
          :status => 422,
          :body   => {
            "error"       => "RecordInvalid",
            "description" => "Record validation errors",
            "details" => {
              "email" => [ {
                "description" => "Email: #{email} is already being used by another user"
              } ]
            }
          }
        )
      else
        user_identity_identity = self.class.new_id # ugh

        user_identity = {
          "id"         => user_identity_identity,
          "url"        => url_for("/users/#{identity}/identities/#{user_identity_identity}.json"),
          "created_at" => Time.now.iso8601,
          "updated_at" => Time.now.iso8601,
          "type"       => "email",
          "value"      => record["email"],
          "verified"   => false,
          "primary"    => true,
          "user_id"    => identity,
        }

        self.data[:identities][user_identity_identity] = user_identity
        self.data[:users][identity] = record

        response(
          :method => :post,
          :body   => {"user" => record},
          :path   => path,
        )
      end
    end
  end # Mock
end
