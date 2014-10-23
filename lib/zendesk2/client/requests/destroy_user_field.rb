class Zendesk2::Client
  class Real
    def destroy_user_field(params={})
      id = params["id"]

      request(
        :method => :delete,
        :path   => "/user_fields/#{id}.json"
      )
    end
  end

  class Mock
    def destroy_user_field(params={})
      id   = params["id"]
      body = self.delete!(:user_fields, id)

      response(
        :method => :delete,
        :path   => "/user_fields/#{id}.json",
        :body   => {
          "user_field" => body,
        },
      )
    end
  end
end
