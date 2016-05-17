class Zendesk2::Membership < Zendesk2::Model
  extend Zendesk2::Attributes

  # @return [Integer] Automatically assigned upon creation
  identity :id, type: :integer

  # @return [Time] The time the identity got created
  attribute :created_at, type: :time
  # @return [Boolean] Is membership the default
  attribute :default, type: :boolean
  # @return [Integer] The id of the organization
  attribute :organization_id, type: :integer
  # @return [Time] The time the identity got updated
  attribute :updated_at, type: :time
  # @return [Integer] The id of the user
  attribute :user_id, type: :integer
  # @return [String] The API url of this identity
  attribute :url, type: :string

  assoc_accessor :organization
  assoc_accessor :user

  def save!
    data = if new_record?
             requires :organization_id, :user_id

             service.create_membership("membership" => self.attributes).body["organization_membership"]
           else
             requires :identity

             raise ArgumentError, "update not implemented"
           end

    merge_attributes(data)
  end

  def destroy!
    requires :identity

    service.destroy_membership("membership" => { "id" => self.identity })
  end

  def default!
    requires :identity, :user_id

    self.service.mark_membership_default(
      "membership" => {
        "user_id" => self.user_id,
        "id"      => self.identity
      })

    self.default = true
  end
end
