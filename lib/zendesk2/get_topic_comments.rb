# frozen_string_literal: true
class Zendesk2::GetTopicComments
  include Zendesk2::Request

  request_path do |r| "/topics/#{r.topic_id}/comments.json" end
  request_method :get

  page_params!

  def topic_id
    params.fetch('topic_id')
  end

  def mock
    find!(:topics, topic_id)

    topic_comments = data[:topic_comments].values.select { |c| c['topic_id'] == topic_id }

    page(topic_comments, root: 'topic_comments')
  end
end
