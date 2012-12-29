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

      if body = self.data[:groups][id]
        response(
          :path => path,
          :body => {
            "group" => body
          },
        )
      else 
        response(
          :path   => path,
          :status => 404,
          :body => {"error" => "RecordNotFound", "description" => "Not found"},
        )
      end
    end
  end # Mock
end
