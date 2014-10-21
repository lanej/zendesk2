class Zendesk2::Client::UpdateGroup < Zendesk2::Client::Request
  request_method :put
  request_path { |r| "/groups/#{r.group_id}.json" }
  request_body { |r| { "group" => r.group_params } }

  def group_params
    @_group_params ||= Cistern::Hash.slice(params.fetch("group"), *Zendesk2::Client::CreateGroup.accepted_attributes)
  end

  def group_id
    @_group_id ||= params.fetch("group").fetch("id")
  end

  def mock
    mock_response("group" => find!(:groups, group_id).merge!(group_params))
  end
end
