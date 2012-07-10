class Zendesk2::Client::Organization < Cistern::Model
  identity :id,               type: :integer
  attribute :created_at,      type: :time
  attribute :details,         type: :string
  attribute :domain_names,    type: :array
  attribute :external_id,     type: :integer
  attribute :group_id,        type: :integer
  attribute :shared_comments, type: :boolean
  attribute :shared_tickets,  type: :boolean
  attribute :tags,            type: :array
  attribute :name,            type: :string
  attribute :notes,           type: :array
  attribute :updated_at,      type: :time

  def destroy!
    requires :identity

    connection.destroy_organization("id" => self.identity)
  end

  def destroy
    destroy!
  rescue Zendesk2::Error
    false
  end

  def destroyed?
    !self.reload
  end

  def save
    data = if new_record?
             requires :name
             connection.create_organization(params).body["organization"]
           else
             requires :identity
             connection.update_organization(params).body["organization"]
           end
    merge_attributes(data)
  end

  def users
    requires :identity
    data = connection.get_organization_users("id" => self.identity).body["users"]

    connection.users.load(data)
  end

  def tickets
    requires :identity
    data = connection.get_organization_tickets("id" => self.identity).body["tickets"]

    connection.tickets.load(data)
  end

  private

  def params
    Cistern::Hash.slice(Zendesk2.stringify_keys(attributes), "id", "details", "domain_names", "external_id", "group_id", "shared_comments", "shared_tickets", "tags", "name", "notes")
  end
end
