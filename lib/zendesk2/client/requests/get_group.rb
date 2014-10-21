class Zendesk2::Client::GetGroup < Zendesk2::Client::Request
  request_method :get
  request_path { |r| "/groups/#{r.group_id}.json" }

  def group_id
    @_group_id ||= params.fetch("group").fetch("id")
  end

  def mock
    mock_response("group" => find!(:groups, group_id))
  end
end
