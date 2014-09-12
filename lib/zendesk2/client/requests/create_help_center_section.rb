class Zendesk2::Client
  class Real
    def create_help_center_section(params={})
      category_id = require_parameters(params, "category_id")

      request(
        :body   => {"section" => params},
        :method => :post,
        :path   => "/help_center/categories/#{category_id}/sections.json",
      )
    end
  end # Real

  class Mock
    def create_help_center_section(params={})
      params = Cistern::Hash.stringify_keys(params)

      identity = self.class.new_id

      category_id = require_parameters(params, "category_id")

      locale = params["locale"] ||= "en-us"
      position = self.data[:help_center_sections].select { |a| a["category_id"] == category_id }.size

      record = {
        "id"                => identity,
        "url"               => url_for("/help_center/#{locale}/sections/#{identity}.json"),
        "html_url"          => html_url_for("/hc/#{locale}/sections/#{identity}.json"),
        "author_id"         => current_user["id"],
        "comments_disabled" => false,
        "label_names"       => [],
        "draft"             => false,
        "promoted"          => false,
        "position"          => position,
        "vote_sum"          => 0,
        "vote_count"        => 0,
        "category_id"       => category_id,
        "created_at"        => Time.now.iso8601,
        "updated_at"        => Time.now.iso8601,
        "name"              => "",
        "body"              => "",
        "source_locale"     => locale,
        "outdated"          => false,
      }.merge(params)

      self.data[:help_center_sections][identity] = record

      response(
        :method => :post,
        :body   => {"section" => record},
        :path   => "/sections/#{category_id}.json"
      )
    end
  end # Mock
end # Zendesk2::Client
