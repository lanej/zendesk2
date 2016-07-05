# frozen_string_literal: true
class Zendesk2::CreateHelpCenterTopic
  include Zendesk2::Request

  request_method :post
  request_path { |_| '/community/topics.json' }
  request_body { |r| { 'topic' => r.topic_params } }

  def self.accepted_attributes
    %w(name position description)
  end

  def topic_params
    Cistern::Hash.slice(params.fetch('topic'), *self.class.accepted_attributes)
  end

  def mock
    identity = cistern.serial_id

    position = data[:help_center_topics].size

    record = {
      'id'          => identity,
      'url'         => url_for("/communit/topics/#{identity}.json"),
      'html_url'    => html_url_for("/hc/topics/#{identity}.json"),
      'position'    => position,
      'created_at'  => timestamp,
      'updated_at'  => timestamp,
      'description' => '',
    }.merge(topic_params)

    data[:help_center_topics][identity] = record

    mock_response('topic' => record)
  end
end
