# frozen_string_literal: true
class Zendesk2::GetTicketFields
  include Zendesk2::Request

  request_method :get
  request_path do |_| '/ticket_fields.json' end

  page_params!

  def mock
    resources(:ticket_fields)
  end
end
