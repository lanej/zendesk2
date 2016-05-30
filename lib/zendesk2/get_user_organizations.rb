# frozen_string_literal: true
class Zendesk2::GetUserOrganizations
  include Zendesk2::Request

  request_method :get
  request_path do |r| "/users/#{r.user_id}/organizations.json" end

  page_params!

  def user_id
    params.fetch('user_id').to_i
  end

  def mock
    memberships = data[:memberships].values.select { |m| m['user_id'] == user_id }
    organizations = memberships.map { |m| data[:organizations].fetch(m['organization_id']) }

    page(organizations, root: 'organizations')
  end
end
