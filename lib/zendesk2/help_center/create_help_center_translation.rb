# frozen_string_literal: true
class Zendesk2::CreateHelpCenterTranslation
  include Zendesk2::Request
  include Zendesk2::HelpCenter::TranslationSource::Request

  request_method :post
  request_path { |r| "/help_center/#{r.source_type_url}/#{r.source_id}/translations/#{r.locale}.json" }
  request_body { |r| { 'translation' => r.translation_params } }

  def self.accepted_attributes
    %w(locale title body outdated draft)
  end

  def translation_params
    Cistern::Hash.slice(params.fetch('translation'), *self.class.accepted_attributes)
  end

  def mock
    identity = cistern.serial_id

    record = {
      'id'                => identity,
      'url'               => url_for("/help_center/#{source_type_url}/#{source_id}/translation/#{locale}.json"),
      'html_url'          => html_url_for("/hc/#{locale}/#{source_type_url}/#{source_id}"),
      'created_at'        => timestamp,
      'updated_at'        => timestamp,
      'title'             => params.fetch('translation').fetch('title'),
      'body'              => (params.fetch('translation')['body'] || ''),
      'outdated'          => false,
      'draft'             => false,
      'locale'            => locale,
    }.merge(translation_params)

    cistern.data[:help_center_translations][mock_translation_key] = record

    mock_response('translation' => record)
  end
end
