# frozen_string_literal: true
class Zendesk2::DestroyTicket
  include Zendesk2::Request

  request_method :delete
  request_path { |r| "/tickets/#{r.ticket_id}.json" }

  def ticket_id
    @_ticket_id ||= params.fetch('ticket').fetch('id')
  end

  def mock
    delete!(:tickets, ticket_id)

    mock_response(nil)
  end
end
