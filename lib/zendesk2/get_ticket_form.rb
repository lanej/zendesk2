# frozen_string_literal: true
class Zendesk2::GetTicketForm
  include Zendesk2::Request

  request_method :get
  request_path { |r| "/ticket_forms/#{r.ticket_form_id}.json" }

  def ticket_form_id
    params.fetch('ticket_form').fetch('id').to_i
  end

  def mock
    mock_response('ticket_form' => find!(:ticket_forms, ticket_form_id))
  end
end
