# frozen_string_literal: true
class Zendesk2::CreateTopicComment
  include Zendesk2::Request

  request_method :post
  request_path { |r| "/topics/#{r.topic_id}/comments.json" }
  request_body { |r| { 'topic_comment' => r.topic_comment_params } }

  def self.accepted_attributes
    %w(user_id body informative)
  end

  def topic_id
    params.fetch('topic_comment').fetch('topic_id').to_i
  end

  def topic_comment_params
    Cistern::Hash.slice(params.fetch('topic_comment'), *self.class.accepted_attributes)
  end

  def mock
    identity = cistern.serial_id

    record = {
      'id'         => identity,
      'url'        => url_for("/topics/#{topic_id}/comments/#{identity}.json"),
      'created_at' => Time.now.iso8601,
      'updated_at' => Time.now.iso8601,
      'topic_id'   => topic_id,
    }.merge(topic_comment_params)

    data[:topic_comments][identity] = record

    mock_response('topic_comment' => record)
  end
end
