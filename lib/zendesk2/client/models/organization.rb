class Zendesk2::Client::Organization < Zendesk2::Model
  PARAMS = %w[id details domain_names external_id group_id shared_comments shared_tickets tags name notes]

  identity :id,               type: :integer
  attribute :url,             type: :string
  attribute :created_at,      type: :time
  attribute :details,         type: :string
  attribute :domain_names,    type: :array
  attribute :external_id,     type: :string
  attribute :group_id,        type: :integer
  attribute :shared_comments, type: :boolean
  attribute :shared_tickets,  type: :boolean
  attribute :tags,            type: :array
  attribute :name,            type: :string
  attribute :notes,           type: :string
  attribute :updated_at,      type: :time

  def destroy!
    requires :identity

    connection.destroy_organization("id" => self.identity)
  end

  def save!
    data = if new_record?
             requires :name
             connection.create_organization(params).body["organization"]
           else
             requires :identity
             connection.update_organization(params).body["organization"]
           end
    merge_attributes(data)
  end

  # @return [Zendesk2::Client::Users] users associated with this organization
  def users
    requires :identity
    data = connection.get_organization_users("id" => self.identity).body["users"]

    connection.users.load(data)
  end

  # @return [Zendesk2::Client::Tickets] tickets associated with this organization
  def tickets
    requires :identity
    data = connection.get_organization_tickets("id" => self.identity).body["tickets"]

    connection.tickets.load(data)
  end

  private

  def params
    writable_attributes = Cistern::Hash.slice(Zendesk2.stringify_keys(attributes), *PARAMS)
    writable_attributes.delete("external_id") if writable_attributes["external_id"].to_s == "0"
    writable_attributes.delete("group_id") if writable_attributes["group_id"].to_s == "0"
    writable_attributes
  end
end
