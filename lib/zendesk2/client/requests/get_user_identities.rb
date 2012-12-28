class Zendesk2::Client
  class Real
    def get_user_identities(params={})
      user_id   = params["user_id"]
      page_params = Zendesk2.paging_parameters(params)

      request(
        :params  => page_params,
        :method  => :get,
        :path    => "/users/#{user_id}/identities.json",
      )
    end
  end # Real

  class Mock
    def get_user_identities(params={})
      user_id = params["user_id"]

      page(params, :identities, "/users/#{user_id}/identities.json", "identities", filter: lambda{|c| c.select{|a| a["user_id"] == user_id}})
    end
  end # Mock
end
