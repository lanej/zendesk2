class Zendesk2::Client
  class Real
    def update_user_field(params={})
      id = params.delete("id")

      request(
        :method => :put,
        :path   => "/user_fields/#{id}.json",
        :body   => {
          "user_field" => params
        },
      )
    end
  end
  class Mock
    def update_user_field(params={})
      user_field_id = params.delete("id")

      response(
        :method => :put,
        :path   => "/user_fields/#{user_field_id}.json",
        :body   => {
          "user_field" => find!(:user_fields, user_field_id).merge!(params),
        },
      )
    end
  end
end
