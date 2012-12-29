class Zendesk2::Client
  class Real
    def destroy_group(params={})
      id = params["id"]

      request(
        :method => :delete,
        :path   => "/groups/#{id}.json"
      )
    end
  end

  class Mock
    def destroy_group(params={})
      id   = params["id"]
      body = self.data[:groups][id]
      body["deleted"] = true

      response(
        :method => :delete,
        :path   => "/groups/#{id}.json",
        :body   => {
          "group" => body,
        },
      )
    end
  end
end
