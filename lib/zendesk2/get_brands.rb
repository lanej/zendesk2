# frozen_string_literal: true
class Zendesk2::GetBrands
  include Zendesk2::Request

  request_method :get
  request_path { |_r| '/brands.json' }

  page_params!

  def mock
    page(:brands)
  end
end
