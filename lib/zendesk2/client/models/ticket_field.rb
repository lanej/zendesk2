class Zendesk2::Client::TicketField < Zendesk2::Model
  extend Zendesk2::Attributes

  PARAMS = %w[type title description position active required collapsed_for_agents regexp_for_validation title_in_portal visible_in_portal editable_in_portal required_in_portal tag custom_field_options]

  # @return [integer] Automatically assigned upon creation
  identity :id, type: :integer

  # @return [Boolean] Whether this field is available
  attribute :active, type: :boolean
  # @return [String] If this field should be shown to agents by default or be hidden alongside infrequently used fields
  attribute :collapsed_for_agents, type: :string
  # @return [Date] The time the ticket field was created
  attribute :created_at, type: :date
  # @return [Array] Required and presented for a ticket field of type "tagger"
  attribute :custom_field_options, type: :array
  # @return [String] The description of the purpose of this ticket field, shown to users
  attribute :description, type: :string
  # @return [Boolean] Whether this field is editable by end users
  attribute :editable_in_portal, type: :boolean
  # @return [Integer] A relative position for the ticket fields, determines the order of ticket fields on a ticket
  attribute :position, type: :integer
  # @return [String] Regular expression field only. The validation pattern for a field value to be deemed valid.
  attribute :regexp_for_validation, type: :string
  # @return [Boolean] If this field is not a system basic field that must be present for all tickets on the account
  attribute :removable, type: :boolean
  # @return [Boolean] If it's required for this field to have a value when updated by agents
  attribute :required, type: :boolean
  # @return [Boolean] If it's required for this field to have a value when updated by end users
  attribute :required_in_portal, type: :boolean
  # @return [Array] Presented for a ticket field of type "tickettype", "priority" or "status"
  attribute :system_field_options, type: :array
  # @return [String] A tag value to set for checkbox fields when checked
  attribute :tag, type: :string
  # @return [String] The title of the ticket field
  attribute :title, type: :string
  # @return [String] The title of the ticket field when shown to end users
  attribute :title_in_portal, type: :string
  # @return [String] The type of the ticket field
  attribute :type, type: :string
  # @return [Date] The time of the last update of the ticket field
  attribute :updated_at, type: :date
  # @return [String] The URL for this resource
  attribute :url, type: :string
  # @return [Boolean] Whether this field is available to end users
  attribute :visible_in_portal, type: :boolean

  def save!
    data = if new_record?
             requires :type, :title

             connection.create_ticket_field(params).body["ticket_field"]
           else
             requires :identity

             connection.update_ticket_field(params.merge("id" => self.identity)).body["ticket_field"]
           end

    merge_attributes(data)
  end

  def destroy!
    requires :identity

    connection.destroy_ticket_field("id" => self.identity)
  end

  private

  def params
    Cistern::Hash.slice(Zendesk2.stringify_keys(attributes), *PARAMS)
  end
end
