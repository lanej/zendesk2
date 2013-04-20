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
      user_id = self.class.new_id
      path    = "/users.json"

      record = {
        "id"         => user_id,
        "url"        => url_for("/users/#{user_id}.json"),
        "created_at" => Time.now.iso8601,
        "updated_at" => Time.now.iso8601,
        "active"     => true,
      }.merge(params)

      if (email = record["email"]) && self.data[:identities].find{|k,i| i["type"] == "email" && i["value"] == email}
        response(
          :method => :put,
          :path   => path,
          :status => 422,
          :body   => {
            "error"       => "RecordInvalid",
            "description" => "Record validation errors",
            "details" => {
              "email" => [ {
                "description" => "Email #{email} is already being used by another user"
              } ]
            }
          }
        )
      else
        user_identity_id = self.class.new_id # ugh

        user_identity = {
          "id"         => user_identity_id,
          "url"        => url_for("/users/#{user_id}/identities/#{user_identity_id}.json"),
          "created_at" => Time.now.iso8601,
          "updated_at" => Time.now.iso8601,
          "type"       => "email",
          "value"      => record["email"],
          "verified"   => false,
          "primary"    => true,
          "user_id"    => user_id,
        }

        self.data[:identities][user_identity_id] = user_identity
        self.data[:users][user_id] = record.reject{|k,v| k == "email"}

        response(
          :method => :post,
          :body   => {"user" => record},
          :path   => path,
        )
      end
    end
  end # Mock
end
