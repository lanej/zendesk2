class Zendesk2::Client::GetRequestedTickets < Zendesk2::Client::Request
  request_method :get
  request_path { |r| "/users/#{r.user_id}/tickets/requested.json" }

  page_params!

  def user_id
    params.fetch("user_id").to_i
  end

  def mock(params={})
    tickets = self.data[:tickets].values.select { |u| u["requester_id"] == user_id }

    page(tickets, root: "tickets")
  end
end
