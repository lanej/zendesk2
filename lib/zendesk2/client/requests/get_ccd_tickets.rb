class Zendesk2::Client::GetCcdTickets < Zendesk2::Client::Request
  request_path { |r| "/users/#{r.collaborator_id}/tickets/ccd.json" }

  page_params!

  def collaborator_id
    params.fetch("collaborator_id").to_i
  end

  def mock
    tickets = service.data[:tickets].values.select { |u| u["collaborator_ids"].include?(collaborator_id) }

    page(tickets, root: "tickets")
  end
end
