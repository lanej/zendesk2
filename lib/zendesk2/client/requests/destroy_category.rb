class Zendesk2::Client
  class Real
    def destroy_category(params={})
      id = params["id"]

      request(
        :method => :delete,
        :path   => "/categories/#{id}.json"
      )
    end
  end

  class Mock
    def destroy_category(params={})
      id   = params["id"]
      body = self.data[:categories].delete(id)

      response(
        :method => :delete,
        :path   => "/categories/#{id}.json",
        :body   => {
          "category" => body,
        },
      )
    end
  end
end
