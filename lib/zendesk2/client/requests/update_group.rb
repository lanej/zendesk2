class Zendesk2::Client
  class Real
    def update_group(params={})
      id   = params.delete("id")
      path = "/groups/#{id}.json"

      request(
        :method => :put,
        :path   => path,
        :body   => {
          "group" => params
        },
      )
    end
  end
  class Mock
    def update_group(params={})
      id = params.delete("id")

      response(
        :method => :put,
        :path   => "/groups/#{id}.json",
        :body   => {
          "group" => find!(:groups, id).merge!(params)
        },
      )
    end
  end
end
