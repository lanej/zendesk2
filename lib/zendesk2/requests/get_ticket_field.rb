class Zendesk2::GetTicketField < Zendesk2::Request
  request_method :get
  request_path { |r| "/ticket_fields/#{r.ticket_field_id}.json" }

  def ticket_field_id
    params.fetch("ticket_field").fetch("id").to_i
  end

  def mock
    mock_response("ticket_field" => find!(:ticket_fields, ticket_field_id))
  end
end
