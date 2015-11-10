class Zendesk2::UpdateUserField < Zendesk2::Request
  request_method :put
  request_path { |r| "/user_fields/#{r.user_field_id}.json" }

  def user_field_id
    params.fetch("user_field").fetch("id")
  end

  def user_field_params
    Cistern::Hash.slice(params.fetch("user_field"), *Zendesk2::CreateUserField.accepted_attributes)
  end

  def mock
    mock_response("user_field" => find!(:user_fields, user_field_id).merge!(user_field_params))
  end
end
