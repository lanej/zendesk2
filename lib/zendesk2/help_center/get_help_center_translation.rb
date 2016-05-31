# frozen_string_literal: true
class Zendesk2::GetHelpCenterTranslation
  include Zendesk2::Request
  include Zendesk2::HelpCenter::TranslationSource::Request

  request_method :get
  request_path do |r|
    "/help_center/#{r.source_type_url}/#{r.source_id}/translations/#{r.locale}.json"
  end

  def mock(_params = {})
    mock_response('translation' => find!(:help_center_translations, mock_translation_key))
  end
end
