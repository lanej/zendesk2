class Zendesk2::Client
  class Real
    def update_help_center_article(params={})
      id     = require_parameters(params, "id")
      locale = params["locale"]

      path = if locale
               "/help_center/#{locale}/articles/#{id}.json"
             else
               "/help_center/articles/#{id}.json"
             end

      request(
        :method => :put,
        :path   => path,
        :body   => {
          "article" => params
        },
      )
    end
  end
  class Mock
    def update_help_center_article(params={})
      params = Cistern::Hash.stringify_keys(params)

      require_parameters(params, "id")

      id     = params.delete("id")
      locale = params["locale"]

      path = if locale
               "/help_center/#{locale}/articles/#{id}.json"
             else
               "/help_center/articles/#{id}.json"
             end

      body = self.data[:help_center_articles][id.to_i].merge!(params)

      response(
        :method => :put,
        :path   => path,
        :body   => {
          "article" => body,
        },
      )
    end
  end
end
