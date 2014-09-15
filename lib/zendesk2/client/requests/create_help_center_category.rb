class Zendesk2::Client
  class Real
    def create_help_center_category(params={})
      params = Cistern::Hash.stringify_keys(params)

      require_parameters(params, "name")

      request(
        :body   => {"category" => params},
        :method => :post,
        :path   => "/help_center/categories.json",
      )
    end
  end # Real

  class Mock
    def create_help_center_category(params={})
      params = Cistern::Hash.stringify_keys(params)

      require_parameters(params, "name")

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
