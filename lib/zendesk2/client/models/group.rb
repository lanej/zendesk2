class Zendesk2::Client::Group < Zendesk2::Model
  extend Zendesk2::Attributes

  PARAMS = %w[name]

  # @return [Integer] Automatically assigned when creating groups
  identity :id, type: :integer

  # @return [Time] The time the group was created
  attribute :created_at, type: :time
  # @return [Boolean] Deleted groups get marked as such
  attribute :deleted, type: :boolean
  # @return [String] The name of the group
  attribute :name, type: :string
  # @return [Time] The time of the last update of the group
  attribute :updated_at, type: :time
  # @return [String] The API url of this group
  attribute :url, type: :string

  def save!
    data = if new_record?
             requires :name
             connection.create_group(params).body["group"]
           else
             requires :identity
             connection.update_group(params.merge("id" => self.identity)).body["group"]
           end

    merge_attributes(data)
  end

  def destroy!
    requires :identity

    connection.destroy_group("id" => self.identity)
    self.deleted = true
  end

  def destroyed?
    self.deleted
  end

  private

  def params
    Cistern::Hash.slice(Zendesk2.stringify_keys(attributes), *PARAMS)
  end
end
