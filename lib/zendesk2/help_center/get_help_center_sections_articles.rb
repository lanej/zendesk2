# frozen_string_literal: true
class Zendesk2::GetHelpCenterSectionsArticles
  include Zendesk2::Request

  request_path do |r|
    locale = r.params['locale']

    if locale
      "/help_center/#{locale}/sections/#{r.section_id}/articles.json"
    else
      "/help_center/sections/#{r.section_id}/articles.json"
    end
  end

  page_params!

  def section_id
    Integer(params.fetch('section_id'))
  end

  def mock
    find!(:help_center_sections, section_id)

    mock_response('articles' => data[:help_center_articles].values.select { |s| s['section_id'] == section_id })
  end
end
