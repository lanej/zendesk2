class Zendesk2::Client::Forum < Zendesk2::Model
  extend Zendesk2::Attributes

  PARAMS = %w[id name description category_id organization_id locale_id locked position forum_type access]

  identity :id,                 type: :integer # ro yes mandatory no  Automatically assigned upon creation
  attribute :url,               type: :string  # ro yes mandatory no  The API url of this forum
  attribute :name,              type: :string  # ro no mandatory yes The name of the forum
  attribute :description,       type: :string  # ro no mandatory no  A description of the forum
  attribute :category_id,       type: :integer # ro no mandatory no  Category this forum is in
  attribute :organization_id,   type: :integer # ro no mandatory no  Organization this forum is restricted to
  attribute :locale_id,         type: :integer # ro no mandatory no  User locale id this forum is restricted to
  attribute :locked,            type: :boolean # ro no mandatory no  Whether this forum is locked such that new entries and comments cannot be made
  attribute :unanswered_topics, type: :integer # ro yes mandatory no  Contains the number of unanswered questions if this forum's topics are questions.
  attribute :position,          type: :integer # ro no mandatory no  The position of this forum relative to other forums in the same category
  attribute :forum_type,        type: :string  # ro no mandatory no  The type of the topics in this forum, valid values: "articles", "ideas" or "questions"
  attribute :access,            type: :string  # ro no mandatory no  Who has access to this forum, valid values: "everybody", "logged-in users" or "agents only"
  attribute :created_at,        type: :date    # ro yes mandatory no  The time the forum was created
  attribute :updated_at,        type: :date    # ro yes mandatory no  The time of the last update of the forum

  assoc_accessor :organization
  assoc_accessor :category

  def destroy!
    requires :identity

    connection.destroy_forum("id" => self.identity)
  end

  def save!
    data = if new_record?
             requires :name
             connection.create_forum(params).body["forum"]
           else
             requires :identity
             connection.update_forum(params).body["forum"]
           end
    merge_attributes(data)
  end

  private

  def params
    Cistern::Hash.slice(Zendesk2.stringify_keys(attributes), *PARAMS)
  end
end
