class Zendesk2::GetTopic < Zendesk2::Request
  request_path { |r| "/topics/#{r.topic_id}.json" }

  def topic_id
    params.fetch("topic").fetch("id")
  end

  def mock
    mock_response("topic" => self.find!(:topics, topic_id))
  end
end
