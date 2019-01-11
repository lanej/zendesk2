# frozen_string_literal: true
class Zendesk2::GetTicketForms
  include Zendesk2::Request

  request_method :get
  request_path { |_| '/ticket_forms.json' }

  page_params!

  def mock
    page(:ticket_forms)
  end
end
