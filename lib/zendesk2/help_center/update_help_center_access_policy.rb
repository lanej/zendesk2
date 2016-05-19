class Zendesk2::UpdateHelpCenterAccessPolicy < Zendesk2::Request
  request_method :put
  request_body { |r| { "access_policy" => r.access_policy_params } }
  request_path { |r|
    "/help_center/sections/#{r.section_id}/access_policy.json"
  }

  def self.accepted_attributes
    %w[viewable_by managable_by restricted_to_group_ids restricted_to_organization_ids required_tags]
  end

  def access_policy_params
    @_section_params ||= Cistern::Hash.slice(params.fetch("access_policy"), *Zendesk2::UpdateHelpCenterAccessPolicy.accepted_attributes)
  end

  def section_id
    params.fetch("section_id")
  end

  def mock
    mock_response("access_policy" => self.find!(:help_center_access_policies, section_id).merge!(access_policy_params))
  end
end
