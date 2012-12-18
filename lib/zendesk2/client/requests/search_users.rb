class Zendesk2::Client
  class Real
    def search_users_by_email(params={})
      page_params = Zendesk2.paging_parameters(params)

      request(
        :params  => page_params.merge(:query => params[:email]),
        :method  => :get,
        :path    => "/users/search.json",
      )
    end
  end
  class Mock
    def search_users_by_email(params={})
      page(params, :users, "/users/search.json", "users", :filter => proc { |items| items.select { |i| i['email'] == params[:email] } })
    end
  end
end
