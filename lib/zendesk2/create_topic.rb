class Zendesk2::CreateTopic < Zendesk2::Request
  request_method :post
  request_body { |r| { "topic" => r.topic_params } }
  request_path { |_| "/topics.json" }

  def self.accepted_attributes
    %w[title body submitter_id updater_id forum_id locked pinned highlighted position tags]
  end

  def topic_params
    @_topic_params ||= Cistern::Hash.slice(params.fetch("topic"), *self.class.accepted_attributes)
  end

  def mock
    identity = service.serial_id

    record = {
      "id"         => identity,
      "url"        => url_for("/topics/#{identity}.json"),
      "created_at" => Time.now.iso8601,
      "updated_at" => Time.now.iso8601,
    }.merge(topic_params)

    self.data[:topics][identity] = record

    mock_response("topic" => record)
  end
end
