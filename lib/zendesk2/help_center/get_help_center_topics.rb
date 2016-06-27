# frozen_string_literal: true
class Zendesk2::GetHelpCenterTopics
  include Zendesk2::Request

  request_path { |_r| '/community/topics.json' }

  def mock
    resources(:help_center_topics, root: 'topics')
  end
end
