class Zendesk2::UpdateOrganization < Zendesk2::Request
  request_method :put
  request_path { |r| "/organizations/#{r.organization_id}.json" }
  request_body { |r| { "organization" => r.organization_params } }

  def organization_params
    @_organization_params ||= Cistern::Hash.slice(organization, *Zendesk2::CreateOrganization.accepted_attributes)
  end

  def organization
    params.fetch("organization")
  end

  def organization_id
    organization.fetch("id").to_i
  end

  def mock
    record = self.find!(:organizations, organization_id)

    other_organizations = service.data[:organizations].dup
    other_organizations.delete(organization_id)

    if organization["name"] && other_organizations.values.find { |o| o["name"].downcase == organization["name"].downcase }
      error!(:invalid, details: {"name" => [ { "description" => "Name: has already been taken" } ]})
    end

    if organization["external_id"] && other_organizations.values.find { |o| o["external_id"].to_s.downcase == organization["external_id"].to_s.downcase }
      error!(:invalid, details: {"name" => [ { "description" => "External has already been taken" } ]})
    end

    record.merge!(organization_params)

    mock_response("organization" => record)
  end
end
