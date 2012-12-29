class Zendesk2::Client::Tickets < Zendesk2::Collection
  include Zendesk2::Searchable

  model Zendesk2::Client::Ticket

  self.collection_method = :get_tickets
  self.collection_root   = "tickets"
  self.model_method      = :get_ticket
  self.model_root        = "ticket"
  self.search_type       = "ticket"
end
