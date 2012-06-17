class Zendesk2::Client
  class Real
    def get_users(params={})
      page_params = Zendesk2.paging_parameters(params)

      request(
        :params  => page_params,
        :method  => :get,
        :path    => "/users.json",
      )
    end
  end
  class Mock
    def get_users(params={})
      page(params, :users, "/users.json", "users")
    end
  end
end
