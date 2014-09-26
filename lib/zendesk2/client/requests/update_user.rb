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

      email = params["email"]

      existing_identity = self.data[:identities].values.find { |i| i["type"] == "email" && i["value"] == email }

      if existing_identity && existing_identity["user_id"] != user_id
        # email not allowed to conflict across users
        error!(:invalid, details: { "email" => [ {
          "description" => "Email #{params["email"]} is already being used by another user",
        } ] })
      elsif existing_identity && existing_identity["user_id"] == user_id
        # no-op email already used
      else
        # add a new identity
        user_identity_id = self.class.new_id # ugh

        user_identity = {
          "id"         => user_identity_id,
          "url"        => url_for("/users/#{user_id}/identities/#{user_identity_id}.json"),
          "created_at" => Time.now.iso8601,
          "updated_at" => Time.now.iso8601,
          "type"       => "email",
          "value"      => email,
          "verified"   => false,
          "primary"    => false,
          "user_id"    => user_id,
        }

        self.data[:identities][user_identity_id] = user_identity
      end

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
