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
      id = params["id"]

      response(
        :path  => "/categories/#{id}.json",
        :body  => {
          "category" => find!(:categories, id)
        },
      )
    end
  end # Mock
end
