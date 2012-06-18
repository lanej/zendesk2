class Zendesk2::Client::User < Cistern::Model
  identity :id
  attribute :url
  attribute :external_id
  attribute :name
  attribute :alias
  attribute :created_at, type: :time
  attribute :updated_at, type: :time
  attribute :active, type: :boolean
  attribute :verified, type: :boolean
  attribute :shared
  attribute :locale_id
  attribute :locale
  attribute :time_zone
  attribute :last_login_at, type: :time
  attribute :email
  attribute :phone
  attribute :signature
  attribute :details
  attribute :notes
  attribute :organization_id
  attribute :role
  attribute :custom_role_id
  attribute :moderator
  attribute :ticket_restriction
  attribute :only_private_comments
  attribute :tags
  attribute :suspended
  attribute :photo
  attribute :authenticity_token

  def save
    if new_record?
      requires :name, :email
      data = connection.create_user(params).body["user"]
      merge_attributes(data)
    else
      requires :identity
      data = connection.update_user(params.merge("id" => self.identity)).body["user"]
      merge_attributes(data)
    end
  end

  def destroy
    requires :identity
    raise "don't nuke yourself" if self.email == connection.username

    data = connection.destroy_user("id" => self.identity).body["user"]
    merge_attributes(data)
  end

  def destroyed?
    !self.active
  end

  private

  def params
    Cistern::Hash.slice(Zendesk2.stringify_keys(attributes), "name", "email", "organization_id", "external_id", "alias", "active", "verified", "locate_id", "time_zone", "phone", "signature", "details", "notes", "role", "custom_role_id", "moderator", "ticket_restriction", "only_private_comments")
  end
end
