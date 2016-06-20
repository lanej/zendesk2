# frozen_string_literal: true
class Zendesk2::GetOrganizationMemberships
  include Zendesk2::Request

  request_method :get
  request_path { |r| "/organizations/#{r.organization_id}/organization_memberships.json" }

  page_params!

  def organization_id
    params.fetch('membership').fetch('organization_id').to_i
  end

  def mock
    collection = data[:memberships].values.select { |m| m['organization_id'] == organization_id }

    page(collection, root: 'organization_memberships')
  end
end
