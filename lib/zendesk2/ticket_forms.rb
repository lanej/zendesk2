# frozen_string_literal: true
class Zendesk2::TicketForms
  include Zendesk2::Collection

  include Zendesk2::Searchable

  model Zendesk2::TicketForm

  attribute :count, type: :integer

  self.collection_method = :get_ticket_forms
  self.collection_root   = 'ticket_forms'
  self.model_method      = :get_ticket_form
  self.model_root        = 'ticket_form'
  self.search_type       = 'ticket_form'
end
