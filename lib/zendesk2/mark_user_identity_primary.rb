class Zendesk2::MarkUserIdentityPrimary < Zendesk2::Request
  request_path { |r| "/users/#{r.user_id}/identities/#{r.user_identity_id}/make_primary.json" }
  request_method :put

  def user_id
    params.fetch("user_identity").fetch("user_id")
  end

  def user_identity_id
    params.fetch("user_identity").fetch("id")
  end

  def mock
    user_identity = self.find!(:identities, user_identity_id)

    # only one user can be primary
    other_user_identities = service.data[:identities].values.select { |i| i["user_id"] == user_id }
    other_user_identities.map { |i| i["primary"] = false }

    user_identity.merge!("primary" => true)

    mock_response(nil)
  end
end
