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
      id   = params.delete("id")
      path = "/groups/#{id}.json"

      if group = self.data[:groups][id]
        group.merge!(params)
        response(
          :method => :put,
          :path   => "/groups/#{id}.json",
          :body   => {
            "group" => group
          },
        )
      else response(status: 404)
      end

    end
  end
end
