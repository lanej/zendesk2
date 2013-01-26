class Zendesk2::Client
  class TicketNotification < AuditEvent
    # @return [Integer] Automatically assigned when creating events
    identity :id, type: :integer

    # @return [String] The message sent to the recipients
    attribute :body, type: :string
    # @return [Array] A array of simple object holding the ids and names of the recipients of this notification
    attribute :recipients, type: :array
    # @return [String] The subject of the message sent to the recipients
    attribute :subject, type: :string
    # @return [Hash] A reference to the trigger that created this notification
    attribute :via
  end
end
