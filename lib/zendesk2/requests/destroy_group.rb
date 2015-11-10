class Zendesk2::DestroyGroup < Zendesk2::Request
  request_method :delete
  request_path { |r| "/groups/#{r.group_id}.json" }

  def group_id
    params.fetch("group").fetch("id")
  end

  def mock
    find!(:groups, group_id, params).merge!("deleted" => true)

    mock_response(nil)
  end
end
