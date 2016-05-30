# frozen_string_literal: true
class Zendesk2::GetOrganizations
  include Zendesk2::Request

  request_method :get
  request_path do |_| '/organizations.json' end

  page_params!

  def mock
    page(:organizations)
  end
end
