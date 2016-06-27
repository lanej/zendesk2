# frozen_string_literal: true
class Zendesk2::UpdateHelpCenterTopic
  include Zendesk2::Request

  request_method :put
  request_body { |r| { 'topic' => r.topic_params } }
  request_path { |r| "/community/topics/#{r.topic_id}.json" }

  def topic_params
    Cistern::Hash.slice(params.fetch('topic'), *Zendesk2::CreateHelpCenterTopic.accepted_attributes)
  end

  def topic_id
    params.fetch('topic').fetch('id')
  end

  def mock
    mock_response('topic' => find!(:help_center_categories, topic_id).merge!(topic_params))
  end
end
