class Zendesk2::Client::Organization < Cistern::Model
  include Zendesk2::Errors
  identity :id
  attribute :shared_comments
  attribute :notes
  attribute :tags
  attribute :domain_names
  attribute :group_id
  attribute :external_id
  attribute :name
  attribute :created_at, type: :time
  attribute :details
  attribute :shared_tickets
  attribute :updated_at, type: :time

  def save
    if new_record?
      requires :name
      data = connection.create_organization(attributes).body["organization"]
      merge_attributes(data)
    else
      requires :identity
      params = {
        "id" => self.identity,
        "name" => self.name,
      }
      data = connection.update_organization(params).body["organization"]
      merge_attributes(data)
    end
  end

  def destroy
    requires :identity

    response = connection.destroy_organization("id" => self.identity)
  end

  def destroyed?
    self.reload
  rescue not_found
    true
  end
end
