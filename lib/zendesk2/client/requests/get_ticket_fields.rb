class Zendesk2::Client::GetTicketFields < Zendesk2::Client::Request
  request_method :get
  request_path { |_| "/ticket_fields.json" }

  page_params!

  def mock
    resources(:ticket_fields)
  end
end
