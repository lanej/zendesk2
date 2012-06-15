class Zendesk::Client
  class Real
    def get_user(params)
      id = params["id"]

      request(
        :method => :get,
        :path => "/users/#{id}.json"
      )
    end
  end
  class Mock
  end
end
