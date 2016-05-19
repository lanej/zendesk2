class Zendesk2::GetTicketMetric
  include Zendesk2::Request

  request_method :get
  request_path do |r|
    metric_id ? "/ticket_metrics/#{r.metric_id}.json" : "/tickets/#{r.ticket_id}/metrics.json"
  end

  def metric_id
    params["id"]
  end

  def ticket_id
    params.fetch("ticket_id")
  end

  def mock
    mock_response(
      "ticket_metric" => find!(:ticket_metrics, metric_id)
    )
  end
end
