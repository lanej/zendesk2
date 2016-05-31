# frozen_string_literal: true
class Zendesk2::UpdateHelpCenterAccessPolicy
  include Zendesk2::Request

  request_method :put
  request_body do |r| { 'access_policy' => r.access_policy_params } end
  request_path do |r|
    "/help_center/sections/#{r.section_id}/access_policy.json"
  end

  def self.accepted_attributes
    %w(viewable_by managable_by restricted_to_group_ids restricted_to_organization_ids required_tags)
  end

  def access_policy_params
    Cistern::Hash.slice(params.fetch('access_policy'), *Zendesk2::UpdateHelpCenterAccessPolicy.accepted_attributes)
  end

  def section_id
    params.fetch('section_id')
  end

  def mock
    mock_response('access_policy' => find!(:help_center_access_policies, section_id).merge!(access_policy_params))
  end
end
