class Zendesk2::GetUserIdentity < Zendesk2::Request
  request_path { |r| "/users/#{r.user_id}/identities/#{r.user_identity_id}.json" }

  def user_identity_id
    params.fetch("user_identity").fetch("id").to_i
  end

  def user_id
    params.fetch("user_identity").fetch("user_id").to_i
  end

  def mock
    mock_response("identity" => find!(:identities, user_identity_id))
  end
end
