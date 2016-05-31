# frozen_string_literal: true
class Zendesk2::GetTicketMetrics
  include Zendesk2::Request

  request_method :get
  request_path do '/ticket_metrics.json' end

  page_params!

  def mock
    page(:ticket_metrics, root: 'metrics')
  end
end
