class Zendesk2::UpdateTopic < Zendesk2::Request
  request_method :put
  request_path { |r| "/topics/#{r.topic_id}.json" }
  request_body { |r| { "topic" => r.topic_params } }

  def topic_id
    params.fetch("topic").fetch("id").to_i
  end

  def topic_params
    Cistern::Hash.slice(params.fetch("topic"), *Zendesk2::CreateTopic.accepted_attributes)
  end

  def mock
    mock_response("topic" => self.find!(:topics, topic_id).merge!(topic_params))
  end
end
