class Zendesk2::DestroyUserIdentity < Zendesk2::Request
  request_path { |r| "/users/#{r.user_id}/identities/#{r.user_identity_id}.json" }
  request_method :delete

  def user_id
    params.fetch("user_identity").fetch("user_id")
  end

  def user_identity_id
    params.fetch("user_identity").fetch("id")
  end

  def mock
    mock_response("identity" => self.delete!(:identities, user_identity_id))
  end
end
