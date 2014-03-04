class Zendesk2::Client::Membership < Zendesk2::Model
  extend Zendesk2::Attributes

  PARAMS = %w[user_id organization_id default]

  # @return [Integer] Automatically assigned upon creation
  identity :id, type: :integer

  # @return [Time] The time the identity got created
  attribute :created_at, type: :time
  # @return [Time] The time the identity got updated
  attribute :updated_at, type: :time
  # @return [Integer] The id of the user
  attribute :user_id, type: :integer
  # @return [Integer] The id of the organization
  attribute :organization_id, type: :integer
  # @return [Boolean] Is membership the default
  attribute :default, type: :boolean

  def save!
    data = if new_record?
             requires :organization_id, :user_id

             connection.create_membership(params).body["organization_membership"]
           else
             requires :identity

             raise ArgumentError, "update not implemented"
           end
    merge_attributes(data)
  end

  def destroy
    requires :identity

    connection.destroy_user_identity("user_id" => self.user_id, "id" => self.identity)
  end

  def reload
    requires :identity

    if data = self.connection.user_identities("user_id" => user_id).get(identity)
      new_attributes = data.attributes
      merge_attributes(new_attributes)
      self
    end
  end

  def primary!
    self.connection.mark_user_identity_primary("user_id" => self.user_id, "id" => self.identity)
    self.primary = true
  end

  private

  def params
    Cistern::Hash.slice(Zendesk2.stringify_keys(attributes), *PARAMS)
  end
end
