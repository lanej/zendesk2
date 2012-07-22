class Zendesk2::Client
  class Real
    def get_category(params={})
      id = params["id"]

      request(
        :method => :get,
        :path   => "/categories/#{id}.json"
      )
    end
  end # Real

  class Mock
    def get_category(params={})
      id   = params["id"]
      if body = self.data[:categories][id]

        response(
          :path  => "/categories/#{id}.json",
          :body  => {
            "category" => body
          },
        )
      else 
        response(
          :path   => "/categories/#{id}.json",
          :status => 404
        )
      end
    end
  end # Mock
end
