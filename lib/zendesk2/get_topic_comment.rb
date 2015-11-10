class Zendesk2::GetTopicComment < Zendesk2::Request
  request_method :get
  request_path { |r| "/topics/#{r.topic_id}/comments/#{r.topic_comment_id}.json" }

  def topic_id
    params.fetch("topic_comment").fetch("topic_id")
  end

  def topic_comment_id
    params.fetch("topic_comment").fetch("id")
  end

  def mock
    mock_response("topic_comment" => self.find!(:topic_comments, topic_comment_id))
  end
end
