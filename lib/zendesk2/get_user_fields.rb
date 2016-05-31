# frozen_string_literal: true
class Zendesk2::GetUserFields
  include Zendesk2::Request

  request_method :get
  request_path do '/user_fields.json' end

  page_params!

  def mock(_params = {})
    page(:user_fields)
  end
end
