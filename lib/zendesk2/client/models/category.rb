class Zendesk2::Client::Category < Cistern::Model
  PARAMS = %w[id name description position]

  identity  :id, type: :integer         # ro[yes] mandatory[no]  Automatically assigned during creation
  attribute :url, type: :string         # ro[yes] mandatory[no]  The API url of this category
  attribute :name, type: :string        # ro[no]  mandatory[yes] The name of the category
  attribute :description, type: :string # ro[no]  mandatory[no]  The description of the category
  attribute :position, type: :integer   # ro[no]  mandatory[no]  The position of this category relative to other categories
  attribute :created_at, type: :date    # ro[yes] mandatory[no]  The time the category was created
  attribute :updated_at, type: :date    # ro[yes] mandatory[no]  The time of the last update of the category

  def destroy
    requires :id

    connection.destroy_category("id" => self.id)
  end

  def destroyed?
    !self.reload
  end

  def save
    data = if new_record?
             requires :name
             connection.create_category(params).body["category"]
           else
             requires :id
             connection.update_category(params).body["category"]
           end
    merge_attributes(data)
  end

  private

  def params
    Cistern::Hash.slice(Zendesk2.stringify_keys(attributes), *PARAMS)
  end
end
