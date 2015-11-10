class Zendesk2::DestroyOrganization < Zendesk2::Request
  request_method :delete
  request_path { |r| "/organizations/#{r.organization_id}.json" }

  def organization_id
    params.fetch("organization").fetch("id")
  end

  def mock
    self.delete!(:organizations, organization_id)

    mock_response(nil)
  end
end
