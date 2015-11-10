class Zendesk2::TicketComment < Zendesk2::AuditEvent
  # @return [Integer] Automatically assigned when creating events
  identity :id, type: :integer

  # @return [String] The actual comment made by the author
  attribute :body, type: :string
  # @return [String] The actual comment made by the author formatted to HTML
  attribute :html_body, type: :string
  # @return [Boolean] If this is a public comment or an internal agents only note
  attribute :public, type: :boolea
  # @return [Boolean] If this comment is trusted or marked as being potentially fraudulent
  attribute :trusted, type: :boolean
  # @return [Integer] The id of the author of this comment
  attribute :author_id, type: :integer
  # @return [Array] The attachments on this comment as Attachment objects
  attribute :attachments, type: :array

  # @return [Zendesk2::User] event author
  def author
    requires :author_id

    self.service.users.get(self.author_id)
  end
end
