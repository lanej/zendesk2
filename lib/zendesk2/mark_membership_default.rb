# frozen_string_literal: true
class Zendesk2::MarkMembershipDefault
  include Zendesk2::Request

  request_method :put
  request_path do |r| "/users/#{r.user_id}/organization_memberships/#{r.identity}/make_default.json" end

  def identity
    params.fetch('membership').fetch('id')
  end

  def user_id
    params.fetch('membership').fetch('user_id').to_i
  end

  def mock
    if (membership = find!(:memberships, identity)) && (membership['user_id'] == user_id)
      # only one user can be default
      other_user_memberships = data[:memberships].values.select { |m| m['user_id'] == user_id }
      other_user_memberships.each do |i| i['default'] = false end
      membership['default'] = true

      mock_response(params)
    else
      error!(:not_found)
    end
  end
end
