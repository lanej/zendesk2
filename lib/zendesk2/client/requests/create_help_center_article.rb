class Zendesk2::Client
  class Real
    def create_help_center_article(params={})
      section_id = require_parameters(params, "section_id")
      path = if locale = params["locale"]
              "/help_center/#{locale}/sections/#{section_id}/articles.json"
            else
              "/help_center/sections/#{section_id}/articles.json"
            end


      request(
        :body   => {"article" => params},
        :method => :post,
        :path   => path,
      )
    end
  end # Real

  class Mock
    def create_help_center_article(params={})
      params = Cistern::Hash.stringify_keys(params)

      identity = self.class.new_id

      section_id = *require_parameters(params, "section_id")

      locale = params["locale"] ||= "en-us"
      position = self.data[:help_center_articles].values.select { |a| a["section_id"] == section_id }.size

      record = {
        "id"                => identity,
        "url"               => url_for("/help_center/#{locale}/articles/#{identity}.json"),
        "html_url"          => html_url_for("/hc/#{locale}/articles/#{identity}.json"),
        "author_id"         => current_user["id"],
        "comments_disabled" => false,
        "label_names"       => [],
        "draft"             => false,
        "promoted"          => false,
        "position"          => position,
        "vote_sum"          => 0,
        "vote_count"        => 0,
        "section_id"        => section_id,
        "created_at"        => Time.now.iso8601,
        "updated_at"        => Time.now.iso8601,
        "title"             => "",
        "body"              => "",
        "source_locale"     => locale,
        "outdated"          => false,
      }.merge(params)

      self.data[:help_center_articles][identity] = record

      response(
        :method => :post,
        :body   => {"article" => record},
        :path   => "/sections/#{section_id}.json"
      )
    end
  end # Mock
end # Zendesk2::Client
