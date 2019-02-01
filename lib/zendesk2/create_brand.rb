# frozen_string_literal: true
class Zendesk2::CreateBrand
  include Zendesk2::Request

  request_method :post
  request_path { |_| '/brands.json' }
  request_body { |r| { 'brand' => r.brand_params } }

  def self.accepted_attributes
    %w(name brand_url has_help_center help_center_state active default ticket_form_ids subdomain host_mapping signature_template)
  end

  def brand_params
    Cistern::Hash.slice(params.fetch('brand'), *self.class.accepted_attributes)
  end

  def mock
    identity = cistern.serial_id

    record = {
      'id'                   => identity,
      'name'                 => params['name'],
      'brand_url'            => '',
      'has_help_center'      => true,
      'help_center_state'    => true,
      'active'               => true,
      'end_user_visible'     => true,
      'default'              => false,
      'ticket_form_ids'      => params['ticket_form_ids'],
      'subdomain'            => params['subdomain'],
      'host_mapping'         => '',
      'signature_template'   => '',
      'url'                  => url_for("/brands/#{identity}.json"),
    }.merge(brand_params)

    data[:brands][identity] = record

    mock_response('brand' => record)
  end
end
