# frozen_string_literal: true
class Zendesk2::UserIdentity
  include Zendesk2::Model

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

             cistern.create_user_identity('user_identity' => attributes)
           else
             requires :identity

             cistern.update_user_identity('user_identity' => attributes)
           end.body['identity']

    merge_attributes(data)
  end

  def destroy!
    requires :identity

    cistern.destroy_user_identity('user_identity' => { 'user_id' => user_id, 'id' => identity })
  end

  def reload
    requires :identity

    model = cistern.user_identities('user_id' => user_id).get(identity)

    return false unless model

    merge_attributes(model.attributes)
    self
  end

  def primary!
    cistern.mark_user_identity_primary('user_identity' => { 'user_id' => user_id, 'id' => identity })
    self.primary = true
  end
end
