class Zendesk2::Client::UserField < Zendesk2::Model
  extend Zendesk2::Attributes

  PARAMS = %w[key type title description position active, regexp_for_validation tag custom_field_options]

  # @return [Integer] Automatically assigned upon creation
  identity :id, type: :integer

  # @return [Boolean] If true, this field is available for use
  attribute :active, type: :boolean
  # @return [Time] The time the ticket field was created
  attribute :created_at, type: :time
  # @return [Array] Required and presented for a custom field of type "tagger"
  attribute :custom_field_options, type: :array
  # @return [String] User-defined description of this field's purpose
  attribute :description, type: :string
  # @return [String] create A unique key that identifies this custom field. This is used for updating the field and referencing in placeholders.
  attribute :key, type: :string
  # @return [Integer] Ordering of the field relative to other fields
  attribute :position, type: :integer
  # @return [String] Regular expression field only. The validation pattern for a field value to be deemed valid.
  attribute :regexp_for_validation, type: :string
  # @return [String] Optional for custom field of type "checkbox"; not presented otherwise.
  attribute :tag, type: :string
  # @return [String] The title of the custom field
  attribute :title, type: :string
  # @return [String] Supported types: "text", "textarea", "checkbox", "date", "integer", "decimal", "regexp", "tagger" (custom dropdown)
  attribute :type, type: :string
  # @return [Time] The time of the last update of the ticket field
  attribute :updated_at, type: :time
  # @return [String] The URL for this resource
  attribute :url, type: :string

  def save!
    data = if new_record?
             requires :type, :title, :key

             connection.create_user_field(params).body["user_field"]
           else
             requires :identity

             connection.update_user_field(params.merge("id" => self.identity)).body["user_field"]
           end

    merge_attributes(data)
  end

  def destroy!
    requires :identity

    connection.destroy_user_field("id" => self.identity)
  end

  private

  def params
    Cistern::Hash.slice(Zendesk2.stringify_keys(attributes), *PARAMS)
  end
end
