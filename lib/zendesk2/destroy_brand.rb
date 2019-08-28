# frozen_string_literal: true
class Zendesk2::DestroyBrand
  include Zendesk2::Request

  request_method :delete
  request_path { |r| "/brands/#{r.brand_id}.json" }

  def brand_id
    params.fetch('brand').fetch('id')
  end

  def mock
    delete!(:brands, brand_id)

    mock_response(nil)
  end
end
