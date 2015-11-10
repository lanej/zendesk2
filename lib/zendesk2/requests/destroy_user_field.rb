class Zendesk2::DestroyUserField < Zendesk2::Request
  request_method :delete
  request_path { |r| "/user_fields/#{r.user_field_id}.json" }

  def user_field_id
    params.fetch("user_field").fetch("id")
  end

  def mock
    mock_response("user_field" => self.delete!(:user_fields, user_field_id))
  end
end
