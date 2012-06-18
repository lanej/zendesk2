class Zendesk2::Client
  class Real
    def get_accounts(params={})
      page_params = Zendesk2.paging_parameters(params)

      request(
        :params  => page_params,
        :method  => :get,
        :path    => "/accounts.json",
      )
    end
  end
  class Mock
    def get_accounts(params={})
      page(params, :accounts, "/accounts.json", "accounts")
    end
  end
end
