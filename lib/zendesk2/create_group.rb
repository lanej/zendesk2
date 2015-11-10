class Zendesk2::CreateGroup < Zendesk2::Request
  request_method :post
  request_path { |_| "/groups.json" }
  request_body { |r|  { "group" => r.group_params } }

  def self.accepted_attributes
    %w[name]
  end

  def group_params
    @_group_params ||= Cistern::Hash.slice(params.fetch("group"), *self.class.accepted_attributes)
  end

  def mock(params={})
    identity = service.serial_id

    record = {
      "id"         => identity,
      "url"        => url_for("/groups/#{identity}.json"),
      "created_at" => Time.now.iso8601,
      "updated_at" => Time.now.iso8601,
      "deleted"    => false,
    }.merge(group_params)

    self.data[:groups][identity] = record

    mock_response({"group" => record}, {status: 201})
  end
end
