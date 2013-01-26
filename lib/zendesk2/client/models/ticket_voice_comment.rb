class Zendesk2::Client
  class TicketVoiceComment < AuditEvent
    # @return [integer] Automatically assigned when creating events
    identity :id, type: :integer

    # @return [Array] The attachments on this comment as Attachment objects
    attribute :attachments, type: :array
    # @return [Integer] The id of the author of this comment
    attribute :author_id, type: :integer
    # @return [String] The actual comment made by the author
    attribute :body, type: :string
    # @return [String] A hash of properties about the call
    attribute :data, type: :string
    # @return [String] A formatted version of the phone number which dialed the call
    attribute :formatted_from, type: :string
    # @return [String] A formatted version of the phone number which answered the call
    attribute :formatted_to, type: :string
    # @return [String] The actual comment made by the author formatted to HTML
    attribute :html_body, type: :string
    # @return [Boolean] If this is a public comment or an internal agents only note
    attribute :public, type: :boolean
    # @return [Boolean] If true, the ticket requester can see this comment
    attribute :public, type: :boolean
    # @return [Boolean] If this comment is trusted or marked as being potentially fraudulent
    attribute :trusted, type: :boolean
    # @return [String] Has the value VoiceComment
    attribute :type, type: :string

    # @return [Zendesk2::Client::User] event author
    def author
      requires :author_id

      self.connection.users.get(self.author_id)
    end
  end
end
