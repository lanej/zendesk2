class Zendesk2::GetHelpCenterTranslation
  include Zendesk2::Request

  request_method :get
  request_path { |r|
    "/help_center/#{r.source_type_url}/#{r.source_id}/translations/#{r.locale}.json"
  }

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
    params.fetch("translation").fetch("locale")
  end

  def mock(params={})
    key = [source_type, source_id, locale].join("-").each_byte.inject(0) {|char, acc| acc + char }
    mock_response("translation" => self.find!(:help_center_translations, key))
  end
end
