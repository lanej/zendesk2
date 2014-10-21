class Zendesk2::Client::GetTicket < Zendesk2::Client::Request
  request_method :get
  request_path { |r| "/tickets/#{r.ticket_id}.json" }

  def ticket_id
    params.fetch("ticket").fetch("id")
  end

  def mock
    mock_response("ticket" => self.find!(:tickets, ticket_id))
  end
end
