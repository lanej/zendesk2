class Zendesk2::Category < Zendesk2::Model

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
    requires :identity

    service.destroy_category("category" => {"id" => self.identity})
  end

  def save!
    data = if new_record?
             requires :name

             service.create_category(params).body["category"]
           else
             requires :identity

             service.update_category(params).body["category"]
           end

    merge_attributes(data)
  end

  protected

  def params
    {"category" => Cistern::Hash.slice(Zendesk2.stringify_keys(attributes), *Zendesk2::CreateCategory.accepted_attributes)}
  end
end
