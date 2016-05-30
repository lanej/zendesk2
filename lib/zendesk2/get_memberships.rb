# frozen_string_literal: true
class Zendesk2::GetMemberships
  include Zendesk2::Request

  request_method :get
  request_path do |_r| '/organization_memberships.json' end

  page_params!

  def mock
    page(data[:memberships].values, root: 'organization_memberships')
  end
end
