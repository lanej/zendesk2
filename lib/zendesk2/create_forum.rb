class Zendesk2::CreateForum < Zendesk2::Request
  request_method :post
  request_path { |_| "/forums.json" }
  request_body { |r| {"forum" => r.forum_params } }

  def self.accepted_attributes
    %w[name description category_id organization_id locale_id locked position forum_type access]
  end

  def forum_params
    Cistern::Hash.slice(params.fetch("forum"), *self.class.accepted_attributes)
  end

  def mock
    identity = service.serial_id

    record = {
      "id"         => identity,
      "url"        => url_for("/forums/#{identity}.json"),
      "created_at" => Time.now.iso8601,
      "updated_at" => Time.now.iso8601,
    }.merge(Cistern::Hash.slice(params.fetch("forum"), *self.class.accepted_attributes))

    service.data[:forums][identity] = record

    mock_response({"forum" => record}, {status: 201})
  end
end
