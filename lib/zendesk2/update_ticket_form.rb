# frozen_string_literal: true
class Zendesk2::UpdateTicketForm
  include Zendesk2::Request

  request_method :put
  request_path { |r| "/ticket_forms/#{r.ticket_form_id}.json" }
  request_body { |r| { 'ticket_form' => r.ticket_form_params } }

  def ticket_form_id
    params.fetch('ticket_form').fetch('id')
  end

  def ticket_form_params
    Cistern::Hash.slice(params.fetch('ticket_form'), *Zendesk2::CreateTicketForm.accepted_attributes)
  end

  def mock
    mock_response('ticket_form' => find!(:ticket_forms, ticket_form_id).merge!(ticket_form_params))
  end
end
