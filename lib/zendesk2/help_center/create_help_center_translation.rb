class Zendesk2::CreateHelpCenterTranslation
  include Zendesk2::Request

  request_method :post
  request_path { |r| "/help_center/#{r.source_type_url}/#{r.source_id}/translations/#{r.locale}.json" }
  request_body { |r| { "translation" => r.translation_params } }

  def self.accepted_attributes
    %w[locale title body outdated draft]
  end

  def translation_params
    Cistern::Hash.slice(params.fetch("translation"), *self.class.accepted_attributes)
  end

  def source_id
    Integer(params.fetch("translation").fetch("source_id"))
  end

  def source_type
    params.fetch("translation").fetch("source_type")
  end

  def source_type_url
    case source_type
    when "Article"
      "articles"
    when "Section"
      "sections"
    when "Category"
      "categories"
    end
  end

  def locale
    params.fetch("translation").fetch("locale") || "en-us"
  end

  def mock
    identity = service.serial_id

    record = {
      "id"                => identity,
      "url"               => url_for("/help_center/#{source_type_url}/#{source_id}/translation/#{locale}.json"),
      "html_url"          => html_url_for("/hc/#{locale}/#{source_type_url}/#{source_id}"),
      "created_at"        => Time.now.iso8601,
      "updated_at"        => Time.now.iso8601,
      "title"             => params.fetch("translation").fetch("title"),
      "body"              => (params.fetch("translation")["body"] || ""),
      "outdated"          => false,
      "draft"             => false,
      "locale"            => locale,
    }.merge(translation_params)

    # Since Zendesk2::Request#find! calls .to_i on hash keys, we need an integer
    # key for this.
    key = [source_type, source_id, locale].join("-").each_byte.inject(0) {|char, acc| acc + char }
    service.data[:help_center_translations][key] = record

    mock_response("translation" => record)
  end
end
