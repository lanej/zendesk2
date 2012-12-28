class Zendesk2::Client
  class Real
    def update_user_identity(params={})
      id      = params.delete("id")
      user_id = params.delete("user_id")
      path    = "/users/#{user_id}/identities/#{id}.json"

      request(
        :method => :put,
        :path   => path,
        :body   => {
          "identity" => params
        },
      )
    end
  end
  class Mock
    def update_user_identity(params={})
      id      = params.delete("id")
      user_id = params.delete("user_id")
      path    = "/users/#{user_id}/identities/#{id}.json"

      body = self.data[:identities][id].merge!(Cistern::Hash.slice(params, "verified"))
      response(
        :method => :put,
        :path   => path,
        :body   => {
          "identity" => body
        },
      )
    end
  end
end
