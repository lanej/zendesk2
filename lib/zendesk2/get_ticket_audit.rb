class Zendesk2::GetTicketAudit
  include Zendesk2::Request

  request_method :get
  request_path { |r| "/tickets/#{r.ticket_id}/audits/#{r.audit_id}.json" }

  def audit_id
    params.fetch("id")
  end

  def ticket_id
    params.fetch("ticket_id")
  end

  def mock(params={})
    mock_response("ticket_audit" => find!(:ticket_audits, audit_id))
  end
end
