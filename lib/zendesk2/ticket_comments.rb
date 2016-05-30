# frozen_string_literal: true
class Zendesk2::TicketComments
  include Zendesk2::Collection

  include Zendesk2::PagedCollection

  model Zendesk2::TicketComment

  attribute :ticket_id, type: :integer

  self.collection_method = :get_ticket_comments
  self.collection_root   = 'comments'

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
end
