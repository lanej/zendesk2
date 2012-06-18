class Zendesk2::Client
  class Real
    def destroy_account(params={})
      id = params["id"]

      request(
        :method => :delete,
        :path   => "/accounts/#{id}.json"
      )
    end
  end

  class Mock
    def destroy_account(params={})
      id   = params["id"]
      body = self.data[:accounts].delete(id)

      response(
        :method => :delete,
        :path   => "/accounts/#{id}.json",
        :body   => {
          "account" => body,
        },
      )
    end
  end
end
