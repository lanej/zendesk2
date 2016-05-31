# frozen_string_literal: true
class Zendesk2::TicketCommentPrivacyChange < AuditEvent
  # @return [integer] Automatically assigned when creating events
  identity :id, type: :integer

  # @return [Integer] The id if the comment that changed privacy
  attribute :comment_id, type: :integer
  # @return [Boolean] Tells if the comment was made public or private
  attribute :public, type: :boolean

  # @return [Zendesk2::TicketComment] ticket comment pertaining to this privacy change
  def comment
    requires :comment_id

    cistern.ticket_comments.get(comment_id)
  end
end
