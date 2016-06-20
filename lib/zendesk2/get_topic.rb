# frozen_string_literal: true
class Zendesk2::GetTopic
  include Zendesk2::Request

  request_path { |r| "/topics/#{r.topic_id}.json" }

  def topic_id
    params.fetch('topic').fetch('id')
  end

  def mock
    mock_response('topic' => find!(:topics, topic_id))
  end
end
