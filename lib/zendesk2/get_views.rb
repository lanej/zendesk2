# frozen_string_literal: true
class Zendesk2::GetViews
  include Zendesk2::Request

  request_method :get
  request_path do |_r| '/views.json' end

  page_params!

  def mock
    page(:views)
  end
end
