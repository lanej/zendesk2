# frozen_string_literal: true
class Zendesk2::GetOrganization
  include Zendesk2::Request

  request_method :get
  request_path do |r| "/organizations/#{r.organization_id}.json" end

  def organization_id
    params.fetch('organization').fetch('id').to_i
  end

  def mock
    mock_response('organization' => find!(:organizations, organization_id))
  end
end
