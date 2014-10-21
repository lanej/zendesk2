class Zendesk2::Client::GetTickets < Zendesk2::Client::Request
  request_method :get
  request_path { |r| "/tickets.json" }

  page_params!

  def mock
    page(:tickets)
  end
end
