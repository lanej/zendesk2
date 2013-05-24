class Zendesk2::Client::Ticket < Zendesk2::Model
  extend Zendesk2::Attributes

  PARAMS = %w[external_id via requester_id submitter_id assignee_id organization_id subject description fields recipient status collaborator_ids tags]

  # @return [Integer] Automatically assigned when creating tickets
  identity :id, type: :integer
  # @return [Integer] What agent is currently assigned to the ticket
  attribute :assignee_id, type: :integer
  # @return [Array] Who are currently CC'ed on the ticket
  attribute :collaborator_ids, type: :array
  # @return [Time] When this record was created
  attribute :created_at, type: :time
  # @return [Array] The custom fields of the ticket
  attribute :custom_fields, type: :array
  # @return [String] The first comment on the ticket
  attribute :description, type: :string
  # @return [Time] If this is a ticket of type "task" it has a due date. Due date format uses ISO 8601 format.
  attribute :due_at, type: :time
  # @return [String] A unique external id, you can use this to link Zendesk tickets to local records
  attribute :external_id, type: :string
  # @return [Integer] The topic this ticket originated from, if any
  attribute :forum_topic_id, type: :integer
  # @return [Integer] The group this ticket is assigned to
  attribute :group_id, type: :integer
  # @return [Boolean] Is true of this ticket has been marked as a problem, false otherwise
  attribute :has_incidents, type: :boolean
  # @return [Integer] The organization of the requester
  attribute :organization_id, type: :integer
  # @return [String] Priority, defines the urgency with which the ticket should be addressed: "urgent", "high", "normal", "low"
  attribute :priority, type: :string
  # @return [Integer] The problem this incident is linked to, if any
  attribute :problem_id, type: :integer
  # @return [String] The original recipient e-mail address of the ticket
  attribute :recipient, type: :string
  # @return [Integer] The user who requested this ticket
  attribute :requester_id, type: :integer
  # @return [Hash] The satisfaction rating of the ticket, if it exists
  attribute :satisfaction_rating
  # @return [Array] The ids of the sharing agreements used for this ticket
  attribute :sharing_agreement_ids, type: :array
  # @return [String] The state of the ticket, "new", "open", "pending", "hold", "solved", "closed"
  attribute :status, type: :string
  # @return [String] The value of the subject field for this ticket
  attribute :subject, type: :string
  # @return [Integer] The user who submitted the ticket; this is the currently authenticated API user
  attribute :submitter_id, type: :integer
  # @return [Array] The array of tags applied to this ticket
  attribute :tags, type: :array
  # @return [String] The type of this ticket, i.e. "problem", "incident", "question" or "task"
  attribute :type, type: :string
  # @return [Time] When this record last got updated
  attribute :updated_at, type: :time
  # @return [String] The API url of this ticket
  attribute :url, type: :string
  # @return [Hash] This object explains how the ticket was created
  attribute :via

  # @return [Zendesk2::Client::Organization] organization assigned to ticket
  assoc_reader :organization
  # @return [Zendesk2::Client::User] user that requested the ticket
  assoc_accessor :requester, collection: :users
  # @return [Zendesk2::Client::User] user that submitted the ticket
  assoc_reader :submitter, collection: :users

  def save!
    data = if new_record?
             requires :subject, :description

             with_requester = @requester && Zendesk2.stringify_keys(@requester)

             connection.create_ticket(params.merge("requester" => with_requester)).body["ticket"]
           else
             requires :identity
             connection.update_ticket(params.merge("id" => self.identity)).body["ticket"]
           end

    merge_attributes(data)
  end

  def destroy!
    requires :identity

    connection.destroy_ticket("id" => self.identity)
  end

  # Adds a ticket comment
  #
  # @param [String] text comment body
  # @param [Hash] options comment options
  # @option options [Array] :attachments Attachment to upload with comment
  # @option options [Boolean] :public (true)
  def comment(text, options={})
    requires :identity

    options[:public] = true if options[:public].nil?
    comment = Zendesk2.stringify_keys(options).merge("body" => text)

    connection.update_ticket("id" => self.identity, "comment" => comment)
  end

  # @return [Array<Zendesk2::Client::User>] All users CCD on this ticket
  def collaborators
    self.collaborator_ids.map{|cid| self.connection.users.get(cid)}
  end

  # Update list of users to be CCD on this ticket
  # @param [Array<Zendesk2::Client::User>] collaborators list of users
  def collaborators=(collaborators)
    self.collaborator_ids = collaborators.map(&:identity)
  end

  # @return [Zendesk2::Client::TicketAudits] all audits for this ticket
  def audits
    self.connection.ticket_audits(ticket_id: self.identity).all
  end

  # @return [Array<Zendesk2::Client::AuditEvent>] audit events of type 'Comment'
  def comments
    audits.map{|audit| audit.events.select{|e| e.type == "Comment"}}.flatten
  end

  private

  def params
    Cistern::Hash.slice(Zendesk2.stringify_keys(attributes), *PARAMS)
  end
end
