class Zendesk2::Group < Zendesk2::Model
  extend Zendesk2::Attributes

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

             service.create_group("group" => self.attributes)
           else
             requires :identity

             service.update_group("group" => self.attributes)
           end.body["group"]

    merge_attributes(data)
  end

  def destroy!
    requires :identity

    service.destroy_group("group" => {"id" => self.identity})

    self.deleted = true
  end

  def destroyed?
    self.deleted
  end
end
