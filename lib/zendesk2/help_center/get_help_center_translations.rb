class Zendesk2::GetHelpCenterTranslations
  include Zendesk2::Request
  include Zendesk2::HelpCenter::TranslationSource::Request

  request_path { |r| "/help_center/#{r.source_type_url}/#{r.source_id}/translations.json" }
  request_params { |r| r.translation_params }

  page_params!

  def translation_params
    new_params = Cistern::Hash.slice(params, :outdated, :draft)

    # Extract locales and dedup "locale"
    locales = params["locales"] || []
    locales << params["locale"] unless !params["locale"] || params["locale"].empty?
    locales.uniq!
    new_params["locales"] = locales.join(",") unless locales.empty?

    return new_params
  end

  def mock
    page(:help_center_translations, root: "translations")
  end
end
