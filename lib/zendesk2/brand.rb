# frozen_string_literal: true
class Zendesk2::Brand
  include Zendesk2::Model

  extend Zendesk2::Attributes

  # @return [integer] Automatically assigned upon creation
  identity :id, type: :integer

  # @return [String] The API url of this brand
  attribute :url, type: :string
  # @return [String] The name of the brand
  attribute :name, type: :string
  # @return [String] The url of the brand
  attribute :brand_url, type: :string
  # @return [Boolean] If the brand has a Help Center
  attribute :has_help_center, type: :boolean
  # @return [String] The state of the Help Center: enabled, disabled, or restricted
  attribute :help_center_state, type: :string
  # @return [Boolean] If the brand is set as active
  attribute :active, type: :boolean
  # @return [Boolean] Is the brand the default brand for this account
  attribute :default, type: :boolean
  # @return [Attachment] Logo image for this brand
  attribute :logo, type: :Attachment
  # @return [Array] The ids of ticket forms that are available for use by a brand
  attribute :ticket_form_ids, type: :array
  # @return [Date] The time the brand was created
  attribute :created_at, type: :date
  # @return [Date] The time of the last update of the brand
  attribute :updated_at, type: :date
  # @return [String] The subdomain of the brand
  attribute :subdomain, type: :string
  # @return [String] The hostmapping to this brand, if any (only admins view this key)
  attribute :host_mapping, type: :string
  # @return [String] The signature template for a brand
  attribute :signature_template, type: :string

  def save!
    data = if new_record?
             requires :name

             cistern.create_brand('brand' => attributes)
           else
             requires :identity

             cistern.update_brand('brand' => attributes)
           end.body['brand']

    merge_attributes(data)
  end

  def destroy!
    requires :identity

    cistern.destroy_brand('brand' => { 'id' => identity })
  end
end
