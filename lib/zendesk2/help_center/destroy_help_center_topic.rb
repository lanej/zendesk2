# frozen_string_literal: true
class Zendesk2::DestroyHelpCenterTopic
  include Zendesk2::Request

  request_path { |r| "/community/topics/#{r.topic_id}.json" }
  request_method :delete

  def topic_id
    params.fetch('topic').fetch('id')
  end

  def mock
    mock_response('topic' => delete!(:help_center_topics, topic_id))
  end
end
