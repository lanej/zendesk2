class Zendesk2::GetTicketAudits < Zendesk2::Request
  request_method :get
  request_path { |r| "/tickets/#{r.ticket_id}/audits.json" }

  page_params!

  def ticket_id
    params.fetch("ticket_id").to_i
  end

  def mock
    audits = self.data[:ticket_audits].values.select { |a| a["ticket_id"] == ticket_id }

    page(audits, root: "audits")
  end
end
