class Zendesk2::GetRequestedTickets < Zendesk2::Request
  request_method :get
  request_path { |r| "/users/#{r.requester_id}/tickets/requested.json" }

  page_params!

  def requester_id
    params.fetch("requester_id").to_i
  end

  def mock(params={})
    tickets = self.data[:tickets].values.select { |u| u["requester_id"] == requester_id }

    page(tickets, root: "tickets")
  end
end
