class Zendesk2::Client
  class Real
    def update_help_center_category(params={})
      id     = require_parameters(params, "id")
      locale = params["locale"]

      path = if locale
               "/help_center/#{locale}/categories/#{id}.json"
             else
               "/help_center/categories/#{id}.json"
             end

      request(
        :method => :put,
        :path   => path,
        :body   => {
          "category" => params
        },
      )
    end
  end
  class Mock
    def update_help_center_category(params={})
      params = Cistern::Hash.stringify_keys(params)

      require_parameters(params, "id")

      id     = params.delete("id").to_s
      locale = params["locale"]

      path = if locale
               "/help_center/#{locale}/categories/#{id}.json"
             else
               "/help_center/categories/#{id}.json"
             end

      body = self.find!(:help_center_categories, id).merge!(params)

      response(
        :method => :put,
        :path   => path,
        :body   => {
          "category" => body,
        },
      )
    end
  end
end
