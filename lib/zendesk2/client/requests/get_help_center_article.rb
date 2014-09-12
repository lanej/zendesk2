class Zendesk2::Client
  class Real
    def get_help_center_article(params={})
      id     = require_parameters(params, "id")
      locale = params["locale"]

      path = if locale
               "/help_center/#{locale}/articles/#{id}.json"
             else
               "/help_center/articles/#{id}.json"
             end


      request(
        :method => :get,
        :path   => path,
      )
    end
  end # Real

  class Mock
    def get_help_center_article(params={})
      id = require_parameters(params, "id")

      locale = params["locale"]

      path = if locale
               "/help_center/#{locale}/articles/#{id}.json"
             else
               "/help_center/articles/#{id}.json"
             end

      response(
        :path => path,
        :body => {
          "article" => self.find!(:help_center_articles, id.to_i)
        },
      )
    end
  end # Mock
end
