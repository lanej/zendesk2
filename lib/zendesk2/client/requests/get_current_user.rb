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
      current_user # re-seed if necessary

      get_user("id" => @current_user["id"])
    end
  end # Mock
end
