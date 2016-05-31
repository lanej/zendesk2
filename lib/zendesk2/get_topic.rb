# frozen_string_literal: true
class Zendesk2::GetTopic
  include Zendesk2::Request

  request_path do |r| "/topics/#{r.topic_id}.json" end

  def topic_id
    params.fetch('topic').fetch('id')
  end

  def mock
    mock_response('topic' => find!(:topics, topic_id))
  end
end
