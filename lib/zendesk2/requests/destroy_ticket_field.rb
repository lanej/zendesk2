class Zendesk2::DestroyTicketField < Zendesk2::Request
  request_method :delete
  request_path { |r| "/ticket_fields/#{r.ticket_field_id}.json" }

  def ticket_field_id
    params.fetch("ticket_field").fetch("id")
  end

  def mock
    self.delete!(:ticket_fields, ticket_field_id)

    mock_response(nil)
  end
end
