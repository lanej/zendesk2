class Zendesk2::Client
  class Real
    def update_category(params={})
      id = params.delete("id")

      request(
        :method => :put,
        :path   => "/categories/#{id}.json",
        :body   => {
          "category" => params
        },
      )
    end
  end
  class Mock
    def update_category(params={})
      id   = params.delete("id")
      body = self.data[:categories][id].merge!(params)

      response(
        :method => :put,
        :path   => "/categories/#{id}.json",
        :body   => {
          "category" => body
        },
      )
    end
  end
end
