# frozen_string_literal: true
class Zendesk2::GetUsers
  include Zendesk2::Request

  request_method :get
  request_path do '/users.json' end

  page_params!

  def mock(params = {})
    page(:users, params)
  end
end
