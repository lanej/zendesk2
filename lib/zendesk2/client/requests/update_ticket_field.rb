class Zendesk2::Client::UpdateTicketField < Zendesk2::Client::Request
  request_method :put
  request_path { |r| "/ticket_fields/#{r.ticket_field_id}.json" }
  request_body { |r| { "ticket_field" => r.ticket_field_params } }

  def ticket_field_id
    params.fetch("ticket_field").fetch("id")
  end

  def ticket_field_params
    Cistern::Hash.slice(params.fetch("ticket_field"), *Zendesk2::Client::CreateTicketField.accepted_attributes)
  end

  def mock
    mock_response("ticket_field" => self.find!(:ticket_fields, ticket_field_id).merge!(ticket_field_params))
  end
end
