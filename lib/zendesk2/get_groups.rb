# frozen_string_literal: true
class Zendesk2::GetGroups
  include Zendesk2::Request

  request_method :get
  request_path { |_| '/groups.json' }

  page_params!

  def mock
    page(:groups, params)
  end
end
