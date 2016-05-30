# frozen_string_literal: true
class Zendesk2::UpdateTopic
  include Zendesk2::Request

  request_method :put
  request_path do |r| "/topics/#{r.topic_id}.json" end
  request_body do |r| { 'topic' => r.topic_params } end

  def topic_id
    params.fetch('topic').fetch('id').to_i
  end

  def topic_params
    Cistern::Hash.slice(params.fetch('topic'), *Zendesk2::CreateTopic.accepted_attributes)
  end

  def mock
    mock_response('topic' => find!(:topics, topic_id).merge!(topic_params))
  end
end
