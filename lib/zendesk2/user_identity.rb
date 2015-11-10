class Zendesk2::UserIdentity < Zendesk2::Model
  extend Zendesk2::Attributes

  # @return [Integer] Automatically assigned upon creation
  identity :id, type: :integer

  # @return [Time] The time the identity got created
  attribute :created_at, type: :time
  # @return [Boolean] Is true of the primary identity of the user
  attribute :primary, type: :boolean
  # @return [String] One of "email", "twitter", "facebook", "google", or "phone_number"
  attribute :type, type: :string
  # @return [Time] The time the identity got updated
  attribute :updated_at, type: :time
  # @return [String] The API url of this identity
  attribute :url, type: :string
  # @return [Integer] The id of the user
  attribute :user_id, type: :integer
  # @return [String] The identifier for this identity, e.g. an email address
  attribute :value, type: :string
  # @return [Boolean] Is true of the identity has gone through verification
  attribute :verified, type: :boolean

  def save!
    data = if new_record?
             requires :type, :value, :user_id

             service.create_user_identity("user_identity" => self.attributes)
           else
             requires :identity

             service.update_user_identity("user_identity" => self.attributes)
           end.body["identity"]

    merge_attributes(data)
  end

  def destroy!
    requires :identity

    service.destroy_user_identity("user_identity" => { "user_id" => self.user_id, "id" => self.identity })
  end

  def reload
    requires :identity

    if model = self.service.user_identities("user_id" => user_id).get(identity)
      merge_attributes(model.attributes)
      self
    end
  end

  def primary!
    self.service.mark_user_identity_primary("user_identity" => { "user_id" => self.user_id, "id" => self.identity })
    self.primary = true
  end
end
