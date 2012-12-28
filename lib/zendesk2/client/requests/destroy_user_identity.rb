class Zendesk2::Client
  class Real
    def destroy_user_identity(params={})
      id      = params.delete("id")
      user_id = params.delete("user_id")

      request(
        :method => :delete,
        :path   => "/users/#{user_id}/identities/#{id}.json"
      )
    end
  end

  class Mock
    def destroy_user_identity(params={})
      id      = params["id"]
      user_id = params["user_id"]
      path    = "/users/#{user_id}/identities/#{id}.json"

      user_identity = self.data[:identities][id]
      body = self.data[:identities].delete(id)
      response(
        :method => :delete,
        :path   => path,
        :body   => {
          "identity" => body,
        },
      )
    end
  end
end
