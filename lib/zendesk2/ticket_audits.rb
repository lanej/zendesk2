# frozen_string_literal: true
class Zendesk2::TicketAudits
  include Zendesk2::Collection

  include Zendesk2::PagedCollection

  model Zendesk2::TicketAudit

  attribute :ticket_id, type: :integer

  self.collection_method = :get_ticket_audits
  self.collection_root   = 'audits'
  self.model_method      = :get_ticket_audit
  self.model_root        = 'audit'

  def ticket
    cistern.tickets.get(ticket_id)
  end

  def all(params = {})
    requires :ticket_id

    body = cistern.send(collection_method, { 'ticket_id' => ticket_id }.merge(params)).body

    collection = clone.load(body[collection_root])
    collection.merge_attributes(Cistern::Hash.slice(body, 'count', 'next_page', 'previous_page'))
    collection
  end

  def get(id)
    requires :ticket_id
    data = cistern.send(model_method, 'ticket_id' => ticket_id, 'id' => id).body[model_root]
    new(data) if data
  rescue Zendesk2::Error
    nil
  end
end
