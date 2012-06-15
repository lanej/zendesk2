class Zendesk::Client
  class Real
    def create_user(params={})
      request(
        :body => {"user" => params},
        :method => :post,
        :path => "/users.json",
      )
    end
  end # Real
  class Mock
  end # Mock
end
