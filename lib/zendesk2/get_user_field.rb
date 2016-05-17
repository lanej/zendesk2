class Zendesk2::GetUserField < Zendesk2::Request
  request_path { |r| "/user_fields/#{r.user_field_id}.json" }
  request_method :get

  def user_field_id
    params.fetch("user_field").fetch("id")
  end

  def mock
    mock_response("user_field" => find!(:user_fields, user_field_id))
  end
end
