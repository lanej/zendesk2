class Zendesk2::Client
  class Real
    def get_help_center_category(params={})
      id     = require_parameters(params, "id")
      locale = params["locale"]

      path = if locale
               "/help_center/#{locale}/categories/#{id}.json"
             else
               "/help_center/categories/#{id}.json"
             end


      request(
        :method => :get,
        :path   => path,
      )
    end
  end # Real

  class Mock
    def get_help_center_category(params={})
      id = require_parameters(params, "id")

      locale = params["locale"]

      path = if locale
               "/help_center/#{locale}/categories/#{id}.json"
             else
               "/help_center/categories/#{id}.json"
             end

      response(
        :path => path,
        :body => {
          "category" => self.find!(:help_center_categories, id)
        },
      )
    end
  end # Mock
end
