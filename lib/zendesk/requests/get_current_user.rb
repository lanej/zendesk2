class Zendesk::Client
  class Real
    def get_current_user
      request(
        :method => :get,
        :path => "/users/me.json",
      )
    end
  end # Real
  class Mock
    def get_current_user
    end
  end # Mock
end
