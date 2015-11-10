class Zendesk2::GetTopicComments < Zendesk2::Request
  request_path { |r| "/topics/#{r.topic_id}/comments.json" }
  request_method :get

  page_params!

  def topic_id
    params.fetch("topic_id")
  end

  def mock
    self.find!(:topics, topic_id)

    topic_comments = self.data[:topic_comments].values.select { |c| c["topic_id"] == topic_id }

    page(topic_comments, root: "topic_comments")
  end
end
