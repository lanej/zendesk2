# frozen_string_literal: true
class Zendesk2::UpdateTicketField
  include Zendesk2::Request

  request_method :put
  request_path do |r| "/ticket_fields/#{r.ticket_field_id}.json" end
  request_body do |r| { 'ticket_field' => r.ticket_field_params } end

  def ticket_field_id
    params.fetch('ticket_field').fetch('id')
  end

  def ticket_field_params
    Cistern::Hash.slice(params.fetch('ticket_field'), *Zendesk2::CreateTicketField.accepted_attributes)
  end

  def mock
    mock_response('ticket_field' => find!(:ticket_fields, ticket_field_id).merge!(ticket_field_params))
  end
end
