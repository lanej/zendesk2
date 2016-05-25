class Zendesk2::UpdateHelpCenterTranslation
  include Zendesk2::Request
  include Zendesk2::HelpCenter::TranslationSource::Request

  request_method :put
  request_body { |r| { "translation" => r.translation_params } }
  request_path { |r| "/help_center/#{r.source_type_url}/#{r.source_id}/translations/#{r.locale}.json" }

  def translation_params
    @_translation_params ||= Cistern::Hash.slice(params.fetch("translation"), *Zendesk2::CreateHelpCenterTranslation.accepted_attributes)
  end

  def mock
    mock_response("translation" => self.find!(:help_center_translations, mock_translation_key).merge!(translation_params))
  end
end
