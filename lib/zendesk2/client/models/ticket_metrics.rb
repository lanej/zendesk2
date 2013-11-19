class Zendesk2::Client::TicketMetrics < Zendesk2::Collection
  model Zendesk2::Client::TicketMetric

  attribute :ticket_id, type: :integer

  self.collection_method = :get_ticket_metrics
  self.collection_root   = "ticket_metrics"
  self.model_method      = :get_ticket_metric
  self.model_root        = "ticket_metric"
end
