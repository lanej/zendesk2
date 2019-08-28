# frozen_string_literal: true
class Zendesk2::UpdateBrand
  include Zendesk2::Request

  request_method :put
  request_path { |r| "/brands/#{r.brand_id}.json" }
  request_body { |r| { 'brand' => r.brand_params } }

  def brand_id
    params.fetch('brand').fetch('id')
  end

  def brand_params
    Cistern::Hash.slice(params.fetch('brand'), *Zendesk2::CreateTicketForm.accepted_attributes)
  end

  def mock
    mock_response('brand' => find!(:brands, brand_id).merge!(brand_params))
  end
end
