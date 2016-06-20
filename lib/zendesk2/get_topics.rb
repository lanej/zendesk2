# frozen_string_literal: true
class Zendesk2::GetTopics
  include Zendesk2::Request

  request_path { |_r| '/topics.json' }

  page_params!

  def mock
    page(:topics)
  end
end
