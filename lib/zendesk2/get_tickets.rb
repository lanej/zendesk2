class Zendesk2::GetTickets < Zendesk2::Request
  request_method :get
  request_path { |r| "/tickets.json" }

  page_params!

  def mock
    page(:tickets)
  end
end
