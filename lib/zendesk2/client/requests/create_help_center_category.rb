class Zendesk2::Client
  class Real
    def create_help_center_category(params={})
      locale = require_parameters(params, "locale")
      path = if locale = params["locale"]
               "/#{locale}/categories.json"
             else
               "/categories.json"
             end


      request(
        :body   => {"category" => params},
        :method => :post,
        :path   => path,
      )
    end
  end # Real

  class Mock
    def create_help_center_category(params={})
      params = Cistern::Hash.stringify_keys(params)

      identity = self.class.new_id

      locale = params["locale"] ||= "en-us"
      position = self.data[:help_center_categories].size

      record = {
        "id"          => identity,
        "url"         => url_for("/help_center/#{locale}/categories/#{identity}.json"),
        "html_url"    => html_url_for("/hc/#{locale}/categories/#{identity}.json"),
        "author_id"   => current_user["id"],
        "position"    => position,
        "created_at"  => Time.now.iso8601,
        "updated_at"  => Time.now.iso8601,
        "name"        => "",
        "description" => "",
      }.merge(params)

      self.data[:help_center_categories][identity] = record

      response(
        :method => :post,
        :body   => {"category" => record},
        :path   => "/categories.json"
      )
    end
  end # Mock
end # Zendesk2::Client
