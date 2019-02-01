# frozen_string_literal: true
class Zendesk2::GetBrand
  include Zendesk2::Request

  request_method :get
  request_path { |r| "/brands/#{r.brand_id}.json" }

  def brand_id
    params.fetch('brand').fetch('id').to_i
  end

  def mock
    mock_response('brand' => find!(:brands, brand_id))
  end
end
