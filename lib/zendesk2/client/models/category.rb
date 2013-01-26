class Zendesk2::Client::Category < Zendesk2::Model
  PARAMS = %w[id name description position]

  # @return [Integer] Automatically assigned during creation
  identity :id, type: :integer

  # @return [Time] The time the category was created
  attribute :created_at, type: :time
  # @return [String] The description of the category
  attribute :description, type: :string
  # @return [String] The name of the category
  attribute :name, type: :string
  # @return [Integer] The position of this category relative to other categories
  attribute :position, type: :integer
  # @return [Time] The time of the last update of the category
  attribute :updated_at, type: :time
  # @return [String] The API url of this category
  attribute :url, type: :string

  def destroy!
    requires :id

    connection.destroy_category("id" => self.id)
  end

  def save!
    data = if new_record?
             requires :name

             connection.create_category(params).body["category"]
           else
             requires :identity

             connection.update_category(params).body["category"]
           end
    merge_attributes(data)
  end

  private

  def params
    Cistern::Hash.slice(Zendesk2.stringify_keys(attributes), *PARAMS)
  end
end
