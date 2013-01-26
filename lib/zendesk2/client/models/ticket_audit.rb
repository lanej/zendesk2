class Zendesk2::Client::TicketAudit < Cistern::Model
  extend Zendesk2::Attributes

  # @return [Integer] Automatically assigned when creating audits
  identity :id, type: :integer
  # @return [Integer] The ID of the associated ticket
  attribute :ticket_id, type: :integer
  # @return [Hash] Metadata for the audit, custom and system data
  attribute :metadata
  # @return [Hash] This object explains how this audit was created
  attribute :via
  # @return [Time] The time the audit was created
  attribute :created_at, type: :time
  # @return [Integer] The user who created the audit
  attribute :author_id, type: :integer
  # @return [Array] An array of the events that happened in this audit
  attribute :events, type: :array

  def ticket
    requires :ticket_id

    self.connection.tickets.get(self.ticket_id)
  end

  def events
    (self.attributes[:events] || []).map{|ae| Zendesk2::Client::AuditEvent.for(ae.merge(ticket_audit: self, connection: self.connection))}
  end
end
