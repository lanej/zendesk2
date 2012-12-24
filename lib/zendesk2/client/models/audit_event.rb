class Zendesk2::Client::AuditEvent < Cistern::Model
  extend Zendesk2::Attributes
  extend Forwardable

  # @return [Integer] Automatically assigned when creating events
  identity :id, type: :integer
  # @return [String] Has the value Comment
  attribute :type, type: :string
  # @return [String] The actual comment made by the author
  attribute :body, type: :string
  # @return [String] The actual comment made by the author formatted to HTML
  attribute :html_body, type: :string
  # @return [Boolean] If this is a public comment or an internal agents only note
  attribute :public, type: :boolean
  # @return [Boolean] If this comment is trusted or marked as being potentially fraudulent
  attribute :trusted, type: :boolean
  # @return [Integer] The id of the author of this comment
  attribute :author_id, type: :integer
  # @return [Array] The attachments on this comment as Attachment objects
  attribute :attachments, type: :array

  # @return [Zendesk2::Client::TicketAudit] audit that includes this event
  attr_accessor :ticket_audit

  def_delegators :ticket_audit, :created_at

  # @return [Zendesk2::Client::User] event author
  def author
    requires :author_id

    self.connection.users.get(self.author_id)
  end
end
