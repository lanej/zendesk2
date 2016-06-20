# frozen_string_literal: true
class Zendesk2::UpdateOrganization
  include Zendesk2::Request

  request_method :put
  request_path { |r| "/organizations/#{r.organization_id}.json" }
  request_body { |r| { 'organization' => r.organization_params } }

  def organization_params
    @_organization_params ||= Cistern::Hash.slice(organization, *Zendesk2::CreateOrganization.accepted_attributes)
  end

  def organization
    params.fetch('organization')
  end

  def organization_id
    organization.fetch('id').to_i
  end

  def mock
    record = find!(:organizations, organization_id)

    other_organizations = cistern.data[:organizations].dup
    other_organizations.delete(organization_id)

    other_named_organization = other_organizations.values.find do |o|
      o['name'].casecmp(organization['name'].to_s.downcase).zero?
    end

    if organization['name'] && other_named_organization
      error!(:invalid, details: { 'name' => [{ 'description' => 'Name: has already been taken' }] })
    end

    other_external_organization = other_organizations.values.find do |o|
      o['external_id'].to_s.casecmp(organization['external_id'].to_s.downcase).zero?
    end

    if organization['external_id'] && other_external_organization
      error!(:invalid, details: { 'name' => [{ 'description' => 'External has already been taken' }] })
    end

    record.merge!(organization_params)

    mock_response('organization' => record)
  end
end
