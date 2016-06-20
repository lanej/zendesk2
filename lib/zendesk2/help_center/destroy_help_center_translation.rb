# frozen_string_literal: true
class Zendesk2::DestroyHelpCenterTranslation
  include Zendesk2::Request
  include Zendesk2::HelpCenter::TranslationSource::Request

  request_method :delete
  request_path { |r| "/help_center/#{r.source_type_url}/#{r.source_id}/translations/#{r.locale}.json" }

  def mock
    delete!(:help_center_translations, mock_translation_key)

    mock_response(nil)
  end
end
