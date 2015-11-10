class Zendesk2::GetTicketComments < Zendesk2::Request
  request_method :get
  request_path { |r|  "/tickets/#{r.ticket_id}/comments.json" }

  def ticket_id
    params.fetch("ticket_id").to_i
  end

  def mock(params={})
    comments = self.data[:ticket_comments].values.select { |comment| comment["ticket_id"] == ticket_id }

    page(comments, root: "comments")
  end
end
