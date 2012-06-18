class Zendesk2::Client
  class Real
    def get_account(params={})
      id = params["id"]

      request(
        :method => :get,
        :path => "/accounts/#{id}.json"
      )
    end
  end # Real

  class Mock
    def get_account(params={})
      id   = params["id"]
      body = self.data[:accounts][id]

      response(
        :path  => "/accounts/#{id}.json",
        :body  => {
          "account" => body
        },
      )
    end
  end # Mock
end
