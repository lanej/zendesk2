class Zendesk2::GetOrganizationTickets < Zendesk2::Request
  request_method :get
  request_path { |r| "/organizations/#{r.organization_id}/tickets.json" }

  page_params!

  def organization_id
    params.fetch("organization_id").to_i
  end

  def mock(params={})
    requesters = self.data[:users].values.select { |u| u["organization_id"] == organization_id }.map { |s| s["organization_id"] }

    tickets = self.data[:tickets].values.select { |t| requesters.include?(t["organization_id"]) }

    page(tickets, root: "tickets")
  end
end
