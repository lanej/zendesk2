class Zendesk2::Client
  class Real
    def get_user_field(params={})
      id = params["id"]

      request(
        :method => :get,
        :path => "/user_fields/#{id}.json"
      )
    end
  end # Real

  class Mock
    def get_user_field(params={})
      id   = params["id"]

      response(
        :path => "/user_fields/#{id}.json",
        :body => {
          "user_field" => find!(:user_fields, id)
        },
      )
    end
  end # Mock
end
