class Zendesk2::Client
  class Real
    def get_user_identity(params={})
      id      = params["id"]
      user_id = params["user_id"]
      path    = "/users/#{user_id}/identities/#{id}.json"

      request(:path => path)
    end
  end # Real

  class Mock
    def get_user_identity(params={})
      id      = params["id"]
      user_id = params["user_id"]
      path    = "/users/#{user_id}/identities/#{id}.json"

      if body = self.data[:identities][id]
        response(
          :path => path,
          :body => {
            "identity" => body
          },
        )
      else 
        response(
          :path   => path,
          :status => 404,
          :body => {"error" => "RecordNotFound", "description" => "Not found"},
        )
      end
    end
  end # Mock
end
