class Zendesk2::Client
  class Real
    def update_user(params={})
      id = params.delete("id")

      request(
        :method => :put,
        :path   => "/users/#{id}.json",
        :body   => {
          "user" => params
        },
      )
    end
  end
  class Mock
    def update_user(params={})
      user_id = params.delete("id")
      path    = "/users/#{user_id}.json"

      if (email = params["email"]) && self.data[:identities].find{|k,i| i["type"] == "email" && i["value"] == email}
        response(
          :method => :put,
          :path   => path,
          :status => 422,
          :body   => {
            "error"       => "RecordInvalid",
            "description" => "Record validation errors", "details" => {
            "email"       => [ {
                "description" => "Email #{params["email"]} is already being used by another user"
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
          "value"      => params["email"],
          "verified"   => false,
          "primary"    => false,
          "user_id"    => user_id,
        }

        self.data[:identities][user_identity_id] = user_identity
        body = self.data[:users][user_id].merge!(params)
        response(
          :method => :put,
          :path   => path,
          :body   => {
            "user" => body
          },
        )
      end
    end
  end
end
