# frozen_string_literal: true
class Zendesk2::TicketForm
  include Zendesk2::Model

  extend Zendesk2::Attributes

  # @return [integer] Automatically assigned upon creation
  identity :id, type: :integer

  # @return [String] The name of the form
  attribute :name, type: :string
  # @return [String] The dynamic content placeholder, if present, or the "name" value, if not
  attribute :raw_name, type: :string
  # @return [String] The name of the form that is displayed to an end user
  attribute :display_name, type: :string
  # @return [String] The dynamic content placeholder, if present, or the "display_name" value, if not
  attribute :raw_display_name, type: :string
  # @return [Integer] The position of this form among other forms in the account, i.e. dropdown
  attribute :position, type: :integer
  # @return [Boolean] If the form is set as active
  attribute :active, type: :boolean
  # @return [Boolean] Is the form visible to the end user
  attribute :end_user_visible, type: :boolean
  # @return [Boolean] Is the form the default form for this account
  attribute :default, type: :boolean
  # @return [Array] ids of all ticket fields which are in this ticket form
  attribute :ticket_field_ids, type: :array
  # @return [Boolean] Is the form available for use in all brands on this account
  attribute :in_all_brands, type: :boolean
  # @return [Array] ids of all brands that this ticket form is restricted to
  attribute :restricted_brand_ids, type: :array

  def save!
    data = if new_record?
             requires :name

             cistern.create_ticket_form('ticket_form' => attributes)
           else
             requires :identity

             cistern.update_ticket_form('ticket_form' => attributes)
           end.body['ticket_form']

    merge_attributes(data)
  end

  def destroy!
    requires :identity

    cistern.destroy_ticket_form('ticket_form' => { 'id' => identity })
  end
end
