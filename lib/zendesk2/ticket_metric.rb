class Zendesk2::TicketMetric < Cistern::Model
  extend Zendesk2::Attributes

  # @return [Integer] Automatically assigned
  identity :id, type: :integer
  # @return [Integer] The ID of the associated ticket
  attribute :ticket_id, type: :integer
  # @return [Time] The time the audit was created
  attribute :created_at, type: :time
  # @return [Time] The time the audit was last updated
  attribute :updated_at, type: :time

  # @return [Integer] Number of groups this ticket passed through
  attribute :group_stations, type: :integer
  # @return [Integer] Number of assignees this ticket had
  attribute :assignee_stations, type: :integer
  # @return [Integer] Total number of times the ticket was reopened
  attribute :reopens, type: :integer
  # @return [Integer] Total number of times ticket was replied to
  attribute :replies, type: :integer

  # @return [Time] When the assignee last updated the ticket
  attribute :assignee_updated_at, type: :time
  # @return [Time] When the requester last updated the ticket
  attribute :requester_updated_at, type: :time
  # @return [Time] When the status was last updated
  attribute :status_updated_at, type: :time
  # @return [Time] When the ticket was initially assigned
  attribute :initially_assigned_at, type: :time
  # @return [Time] When the ticket was last assigned
  attribute :assigned_at, type: :time
  # @return [Time] When the ticket was solved
  attribute :solved_at, type: :time
  # @return [Time] When the latest comment was added
  attribute :latest_comment_added_at, type: :time

  # @return [Hash] Number of minutes to the first resolution time inside and out of business hours
  attribute :first_resolution_time_in_minutes
  # @return [Hash] Number of minutes to the first reply inside and out of business hours
  attribute :reply_time_in_minutes
  # @return [Hash] Number of minutes to the full resolution inside and out of business hours
  attribute :full_resolution_time_in_minutes
  # @return [Hash] Number of minutes the agent spent waiting inside and out of business hours
  attribute :agent_wait_time_in_minutes
  # @return [Hash] Number of minutes the requester spent waiting inside and out of business hours
  attribute :requester_wait_time_in_minutes

  def ticket
    requires :ticket_id

    self.service.tickets.get(self.ticket_id)
  end

end
