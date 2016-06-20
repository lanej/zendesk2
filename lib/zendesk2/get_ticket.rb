# frozen_string_literal: true
class Zendesk2::GetTicket
  include Zendesk2::Request

  request_method :get
  request_path { |r| "/tickets/#{r.ticket_id}.json" }

  def ticket_id
    params.fetch('ticket').fetch('id')
  end

  def mock
    mock_response('ticket' => find!(:tickets, ticket_id))
  end
end
