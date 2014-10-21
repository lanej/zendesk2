class Zendesk2::Client::GetCcdTickets < Zendesk2::Client::Request
  request_path { |r| "/users/#{r.user_id}/tickets/ccd.json" }

  page_params!

  def user_id
    params.fetch("user_id").to_i
  end

  def mock
    tickets = service.data[:tickets].values.select { |u| u["collaborator_ids"].include?(user_id) }

    page(tickets, root: "tickets")
  end
end
