class Zendesk::Client
  class Real
    def get_users(params)
      request(
        :params => params,
        :method => :get,
        :path => "/users.json"
      )
    end
  end
  class Mock
  end
end
