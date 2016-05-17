class Zendesk2::DestroyTopicComment < Zendesk2::Request
  request_method :delete
  request_path { |r| "/topics/#{r.topic_id}/comments/#{r.topic_comment_id}.json" }

  def topic_id
    params.fetch("topic_comment").fetch("topic_id")
  end

  def topic_comment_id
    params.fetch("topic_comment").fetch("id")
  end

  def mock
    self.delete!(:topic_comments, topic_comment_id)

    mock_response(nil)
  end
end
