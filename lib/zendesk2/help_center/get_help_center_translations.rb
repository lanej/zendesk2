class Zendesk2::GetHelpCenterTranslations
  include Zendesk2::Request

  request_path { |r|
    case r.source_type
    when "Article"
      "/help_center/articles/#{r.source_id}/translations.json"
    when "Section"
      "/help_center/sections/#{r.source_id}/translations.json"
    when "Category"
      "/help_center/categories/#{r.source_id}/translations.json"
    end
  }

  request_params { |r| r.translations_params }

  page_params!

  def source_id
    Integer(params.fetch("source_id"))
  end

  def source_type
    params.fetch("source_type")
  end

  def translations_params
    new_params = Cistern::Hash.slice(params, :outdated, :draft)

    # Extract locales and dedup "locale"
    locales = params["locales"] || []
    locales << params["locale"]
    locales.uniq!
    new_params["locales"] = locales.join(",") unless locales.empty?

    return new_params
  end

  def mock
    page(:help_center_translations, root: "translations")
  end
end
