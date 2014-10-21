class Zendesk2::Client::TicketComments < Zendesk2::Client::Collection
  include Zendesk2::PagedCollection

  model Zendesk2::Client::TicketComment

  attribute :ticket_id, type: :integer

  self.collection_method = :get_ticket_comments
  self.collection_root   = "comments"

  def ticket
    self.service.tickets.get(self.ticket_id)
  end

  def all(params={})
    requires :ticket_id

    body = service.send(collection_method, {"ticket_id" => self.ticket_id}.merge(params)).body

    collection = self.clone.load(body[collection_root])
    collection.merge_attributes(Cistern::Hash.slice(body, "count", "next_page", "previous_page"))
    collection
  end
end
