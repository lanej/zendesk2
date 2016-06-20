# frozen_string_literal: true
class Zendesk2::TicketAudit
  include Zendesk2::Model

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

    cistern.tickets.get(ticket_id)
  end

  def events
    (attributes[:events] || []).map do |ae|
      Zendesk2::AuditEvent.for(ae.merge(ticket_audit: self, cistern: cistern))
    end
  end
end
