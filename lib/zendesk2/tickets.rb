class Zendesk2::Tickets < Zendesk2::Collection
  include Zendesk2::PagedCollection
  include Zendesk2::Searchable
  extend Zendesk2::Attributes

  model Zendesk2::Ticket

  attribute :requester_id,    type: :integer
  attribute :collaborator_id, type: :integer
  attribute :view_id,         type: :integer

  assoc_accessor :requester
  assoc_accessor :collaborator

  self.collection_root = "tickets"
  self.model_method    = :get_ticket
  self.model_root      = "ticket"
  self.search_type     = "ticket"

  def collection_page(params={})
    collection_method = if requester_id
                          :get_requested_tickets
                        elsif collaborator_id
                          :get_ccd_tickets
                        elsif view_id
                          :get_view_tickets
                        else
                          :get_tickets
                        end

    body = service.send(collection_method, Cistern::Hash.stringify_keys(self.attributes.merge(params))).body

    self.load(body[collection_root]) # 'results' is the key for paged searches
    self.merge_attributes(Cistern::Hash.slice(body, "count", "next_page", "previous_page"))
    self
  end

  scopes << :requester_id
  scopes << :collaborator_id
  scopes << :view_id
end
