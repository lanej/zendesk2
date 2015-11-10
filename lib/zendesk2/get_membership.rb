class Zendesk2::GetMembership < Zendesk2::Request
  request_method :get
  request_path { |r| "/organization_memberships/#{r.membership_id}.json" }

  def membership_id
    params.fetch("organization_membership").fetch("id")
  end

  def mock
    mock_response("organization_membership" => find!(:memberships, membership_id))
  end
end
