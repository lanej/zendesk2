# frozen_string_literal: true
class Zendesk2::CreateTicketForm
  include Zendesk2::Request

  request_method :post
  request_path { |_| '/ticket_forms.json' }
  request_body { |r| { 'ticket_form' => r.ticket_form_params } }

  def self.accepted_attributes
    %w(name raw_name display_name raw_display_name position active end_user_visible default ticket_field_ids
       in_all_brands restricted_brand_ids)
  end

  def ticket_form_params
    Cistern::Hash.slice(params.fetch('ticket_form'), *self.class.accepted_attributes)
  end

  def mock
    identity = cistern.serial_id

    record = {
      'id'                   => identity,
      'name'                 => params['name'],
      'raw_name'             => '',
      'display_name'         => '',
      'raw_display_name'     => '',
      'position'             => 9999,
      'active'               => true,
      'end_user_visible'     => true,
      'default'              => false,
      'ticket_field_ids'     => params['ticket_field_ids'],
      'in_all_brands'        => false,
      'restricted_brand_ids' => params['restricted_brand_ids'],
      'url'                  => url_for("/ticket_forms/#{identity}.json"),
    }.merge(ticket_form_params)

    data[:ticket_forms][identity] = record

    mock_response('ticket_form' => record)
  end
end
