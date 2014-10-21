class Zendesk2::Client::GetOrganization < Zendesk2::Client::Request
  request_method :get
  request_path { |r| "/organizations/#{r.organization_id}.json" }

  def organization_id
    params.fetch("organization").fetch("id").to_i
  end

  def mock
    mock_response("organization" => find!(:organizations, organization_id))
  end
end
