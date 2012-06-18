class Zendesk2::Client
  class Real
    def update_account(params={})
      id = params.delete("id")

      request(
        :method => :put,
        :path   => "/accounts/#{id}.json",
        :body   => {
          "account" => params
        },
      )
    end
  end
  class Mock
    def update_account(params={})
      id   = params.delete("id")
      body = self.data[:accounts][id].merge!(params)

      response(
        :method => :put,
        :path   => "/accounts/#{id}.json",
        :body   => {
          "account" => body
        },
      )
    end
  end
end
