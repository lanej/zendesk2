# frozen_string_literal: true
class Zendesk2::GetForums
  include Zendesk2::Request

  request_method :get
  request_path do |_| '/forums.json' end

  page_params!

  def mock
    page(:forums)
  end
end
