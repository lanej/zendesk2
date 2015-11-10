class Zendesk2::TicketFields < Zendesk2::Collection
  include Zendesk2::Searchable

  model Zendesk2::TicketField

  attribute :count, type: :integer

  self.collection_method = :get_ticket_fields
  self.collection_root   = "ticket_fields"
  self.model_method      = :get_ticket_field
  self.model_root        = "ticket_field"
  self.search_type       = "ticket_field"
end
