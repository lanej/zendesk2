class Zendesk2::Forum < Zendesk2::Model
  extend Zendesk2::Attributes

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
  attribute :created_at,        type: :time    # ro yes mandatory no  The time the forum was created
  attribute :updated_at,        type: :time    # ro yes mandatory no  The time of the last update of the forum

  assoc_accessor :organization
  assoc_accessor :category

  def destroy!
    requires :identity

    service.destroy_forum("forum" => {"id" => self.identity})
  end

  def save!
    response = if new_record?
                 requires :name

                 service.create_forum("forum" => self.attributes)
               else
                 requires :identity

                 service.update_forum("forum" => self.attributes)
               end

    merge_attributes(response.body["forum"])
  end
end
