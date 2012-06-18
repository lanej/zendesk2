class Zendesk2::Client::Tickets < Cistern::Collection
  include Zendesk2::PagedCollection

  model Zendesk2::Client::Ticket

  self.collection_method= :get_tickets
  self.collection_root= "tickets"
  self.model_method= :get_ticket
  self.model_root= "ticket"

  def search(term)
    body = connection.search_ticket("query" => term).body
    if data = body.delete("results")
      load(data)
    end
    merge_attributes(body)
  end
end
