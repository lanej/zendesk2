class Zendesk2::Client
  class Real
    def update_help_center_section(params={})
      id     = require_parameters(params, "id")
      locale = params["locale"]

      path = if locale
               "/help_center/#{locale}/sections/#{id}.json"
             else
               "/help_center/sections/#{id}.json"
             end

      request(
        :method => :put,
        :path   => path,
        :body   => {
          "section" => params
        },
      )
    end
  end
  class Mock
    def update_help_center_section(params={})
      params = Cistern::Hash.stringify_keys(params)

      require_parameters(params, "id")

      id     = params.delete("id").to_s
      locale = params["locale"]

      path = if locale
               "/help_center/#{locale}/sections/#{id}.json"
             else
               "/help_center/sections/#{id}.json"
             end

      body = self.find!(:help_center_sections, id).merge!(params)

      response(
        :method => :put,
        :path   => path,
        :body   => {
          "section" => body,
        },
      )
    end
  end
end
