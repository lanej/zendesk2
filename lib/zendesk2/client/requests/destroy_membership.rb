class Zendesk2::Client::DestroyMembership < Zendesk2::Client::Request
  request_method :delete
  request_path { |r| "/organization_memberships/#{r.membership_id}.json" }

  def membership_id
    params.fetch("membership").fetch("id")
  end

  def mock
    delete!(:memberships, membership_id)

    mock_response(nil)
  end
end
