class Zendesk2::Client::Organization < Cistern::Model
  include Zendesk2::Errors
  identity :id,               type: :integer
  attribute :shared_comments, type: :boolean
  attribute :notes,           type: :array
  attribute :tags
  attribute :domain_names,    type: :array
  attribute :group_id,        type: :integer
  attribute :external_id,     type: :integer
  attribute :name
  attribute :created_at,      type: :time
  attribute :details
  attribute :shared_tickets,  type: :boolean
  attribute :updated_at,      type: :time

  def destroy
    requires :identity

    response = connection.destroy_organization("id" => self.identity)
  end

  def destroyed?
    self.reload
  rescue not_found
    true
  end

  def save
    if new_record?
      requires :name
      data = connection.create_organization(attributes).body["organization"]
      merge_attributes(data)
    else
      requires :identity
      params = {
        "id"   => self.identity,
        "name" => self.name,
      }
      data = connection.update_organization(params).body["organization"]
      merge_attributes(data)
    end
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
end
