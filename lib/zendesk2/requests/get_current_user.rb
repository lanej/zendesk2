class Zendesk2::Client
  class Real
    def get_current_user
      request(
        :method => :get,
        :path   => "/users/me.json",
      )
    end
  end # Real

  class Mock
    def get_current_user
      body = self.data[:users][@current_user_id]

      response(
        :path  => "/users/me.json",
        :body  => {
          "user" => body
        },
      )
    end
  end # Mock
end
