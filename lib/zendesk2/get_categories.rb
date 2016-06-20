# frozen_string_literal: true
class Zendesk2::GetCategories
  include Zendesk2::Request

  request_method :get
  request_path { |_| '/categories.json' }

  page_params!

  def mock
    page(:categories)
  end
end
