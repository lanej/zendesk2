class Zendesk2::Client::Ticket < Cistern::Model
  include Zendesk2::Errors
  identity :id
  attribute :external_id
  attribute :via
  attribute :created_at, type: :time
  attribute :updated_at, type: :time
  attribute :type
  attribute :subject
  attribute :description
  attribute :priority
  attribute :status
  attribute :recipient
  attribute :requester_id
  attribute :submitter_id
  attribute :assignee_id
  attribute :organization_id
  attribute :group_id
  attribute :collaborator_ids, type: :array
  attribute :forum_topic_id
  attribute :problem_id
  attribute :has_incidents
  attribute :due_at
  attribute :tags
  attribute :fields

  def save
    if new_record?
      requires :subject, :description
      data = connection.create_ticket(attributes).body["ticket"]
      merge_attributes(data)
    else
      requires :identity
      params = {
        "id" => self.identity,
        "subject" => self.subject,
        "description" => self.description,
      }
      data = connection.update_ticket(params).body["ticket"]
      merge_attributes(data)
    end
  end

  def destroy
    requires :identity

    connection.destroy_ticket("id" => self.identity)
  end

  def destroyed?
    self.reload
  rescue not_found
    true
  end
end
