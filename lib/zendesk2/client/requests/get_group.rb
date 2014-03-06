class Zendesk2::Client
  class Real
    def get_group(params={})
      id = params["id"]

      request(
        :method => :get,
        :path => "/groups/#{id}.json"
      )
    end
  end # Real

  class Mock
    def get_group(params={})
      id   = params["id"]
      path = "/groups/#{id}.json"

      response(
        :path => path,
        :body => {
          "group" => find!(:groups, id),
        },
      )
    end
  end # Mock
end
