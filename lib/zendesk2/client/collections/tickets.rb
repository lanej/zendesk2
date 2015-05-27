class Zendesk2::Client::Tickets < Zendesk2::Client::Collection
  include Zendesk2::PagedCollection
  include Zendesk2::Searchable

  model Zendesk2::Client::Ticket

  attribute :requester_id
  attribute :collaborator_id

  self.collection_root   = "tickets"
  self.model_method      = :get_ticket
  self.model_root        = "ticket"
  self.search_type       = "ticket"

  def collection_page(params={})
    collection_method = if requester_id
                          :get_requested_tickets
                        elsif collaborator_id
                          :get_ccd_tickets
                        else
                          :get_tickets
                        end

    body = service.send(collection_method, Cistern::Hash.stringify_keys(self.attributes.merge(params))).body

    self.load(body[collection_root]) # 'results' is the key for paged seraches
    self.merge_attributes(Cistern::Hash.slice(body, "count", "next_page", "previous_page"))
    self
  end
end
