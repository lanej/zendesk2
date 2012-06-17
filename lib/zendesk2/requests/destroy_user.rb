class Zendesk2::Client
  class Real
    def destroy_user(params={})
      id = params["id"]

      request(
        :method => :delete,
        :path   => "/users/#{id}.json"
      )
    end
  end

  class Mock
    def destroy_user(params={})
      id   = params["id"]
      body = self.data[:users].delete(id)

      response(
        :method => :delete,
        :path   => "/users/#{id}.json",
        :body   => {
          "user" => body,
        },
      )
    end
  end
end
