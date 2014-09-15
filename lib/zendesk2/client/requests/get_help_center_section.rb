class Zendesk2::Client
  class Real
    def get_help_center_section(params={})
      id     = require_parameters(params, "id")
      locale = params["locale"]

      path = if locale
               "/help_center/#{locale}/sections/#{id}.json"
             else
               "/help_center/sections/#{id}.json"
             end


      request(
        :method => :get,
        :path   => path,
      )
    end
  end # Real

  class Mock
    def get_help_center_section(params={})
      id = require_parameters(params, "id")

      locale = params["locale"]

      path = if locale
               "/help_center/#{locale}/sections/#{id}.json"
             else
               "/help_center/sections/#{id}.json"
             end

      response(
        :path => path,
        :body => {
          "section" => self.find!(:help_center_sections, id.to_i)
        },
      )
    end
  end # Mock
end
