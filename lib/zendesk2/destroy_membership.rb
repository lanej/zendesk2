# frozen_string_literal: true
class Zendesk2::DestroyMembership
  include Zendesk2::Request

  request_method :delete
  request_path do |r| "/organization_memberships/#{r.membership_id}.json" end

  def membership_id
    params.fetch('membership').fetch('id').to_i
  end

  def mock
    membership = delete!(:memberships, membership_id)

    primary_organization = data[:memberships].values.find { |m|
      m['user_id'] == membership['user_id'] && m['default']
    } || data[:memberships].values.find { |m| m['user_id'] == membership['user_id'] }

    if primary_organization
      primary_organization['default'] = true
      find!(:users, membership['user_id'].to_i)['organization_id'] = primary_organization['organization_id']
    end

    mock_response(nil)
  end
end
