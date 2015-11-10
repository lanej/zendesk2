class Zendesk2::CreateHelpCenterArticle < Zendesk2::Request
  request_method :post
  request_body { |r| { "article" => r.article_params } }
  request_path { |r|
    if locale = r.article_params["locale"]
      "/help_center/#{locale}/sections/#{r.section_id}/articles.json"
    else
      "/help_center/sections/#{r.section_id}/articles.json"
    end
  }

  def self.accepted_attributes
    %w[author_id body comments_disabled draft label_names locale position promoted section_id title]
  end

  def article_params
    @_article_params ||= Cistern::Hash.slice(params.fetch("article"), *self.class.accepted_attributes)
  end

  def section_id
    params.fetch("article").fetch("section_id")
  end

  def mock
    identity = service.serial_id

    locale = params["locale"] ||= "en-us"
    position = self.data[:help_center_articles].values.select { |a| a["section_id"] == section_id }.size

    record = {
      "id"                => identity,
      "url"               => url_for("/help_center/#{locale}/articles/#{identity}.json"),
      "html_url"          => html_url_for("/hc/#{locale}/articles/#{identity}.json"),
      "author_id"         => service.current_user["id"],
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
    }.merge(article_params)

    self.data[:help_center_articles][identity] = record

    mock_response("article" => record)
  end
end
