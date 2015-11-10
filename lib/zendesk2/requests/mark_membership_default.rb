class Zendesk2::MarkMembershipDefault < Zendesk2::Request
  request_method :put
  request_path { |r| "/users/#{r.user_id}/organization_memberships/#{r.identity}/make_default.json" }

  def identity
    params.fetch("membership").fetch("id")
  end

  def user_id
    params.fetch("membership").fetch("user_id").to_i
  end

  def mock
    if (membership = self.find!(:memberships, identity)) && (membership["user_id"] == user_id)
      # only one user can be default
      other_user_memberships = self.data[:memberships].values.select { |m| m["user_id"]== user_id }
      other_user_memberships.each { |i| i["default"] = false }
      membership["default"] = true

      mock_response(params)
    else
      error!(:not_found)
    end
  end
end
