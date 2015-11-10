class Zendesk2::Topic < Zendesk2::Model
  extend Zendesk2::Attributes

  identity :id, type: :integer # ro[yes] mandatory[no]   Automatically assigned upon creation

  attribute :url,          type: :string  # ro[yes] mandatory[no]   The API url of this topic
  attribute :title,        type: :string  # ro[no] mandatory[yes]   The title of the topic
  attribute :body,         type: :string  # ro[no] mandatory[yes] The unescaped body of the topic
  attribute :topic_type,   type: :string  # ro[yes] mandatory[no] The type of topic. Either "articles", "ideas" or "questions"
  attribute :submitter_id, type: :integer # ro[no] mandatory[no]  The id of the user who submitted the topic
  attribute :updater_id,   type: :integer # ro[no] mandatory[no]  The id of the person to last update the topic
  attribute :forum_id,     type: :integer # ro[no] mandatory[no]  Forum that the topic is associated to
  attribute :locked,       type: :boolean # ro[no] mandatory[no]  Whether comments are allowed
  attribute :pinned,       type: :boolean # ro[no] mandatory[no]  If the topic is marked as pinned and hence eligible to show up on the front page
  attribute :highlighted,  type: :boolean # ro[no] mandatory[no]    Set to true to highlight a topic within its forum
  attribute :answered,     type: :boolean # ro[yes] mandatory[no]   Set to true if the topic is a question and it has been marked as answered.
  attribute :position,     type: :integer # ro[no] mandatory[no]  The position of this topic relative to other topics in the same forum
  attribute :tags,         type: :array   # ro[no] mandatory[no]  The tags set on the topic
  attribute :created_at,   type: :time    # ro[yes] mandatory[no] The time the topic was created

  assoc_accessor :submitter, collection: :users
  assoc_accessor :updater, collection: :users
  assoc_accessor :forum

  def destroy!
    requires :identity

    service.destroy_topic("topic" => {"id" => self.identity})
  end

  def save!
    data = if new_record?
             requires :title, :body

             service.create_topic("topic" => self.attributes)
           else
             requires :identity

             service.update_topic("topic" => self.attributes)
           end.body["topic"]

    merge_attributes(data)
  end

  def comments
    self.topic_comments(topic_id: topic_id)
  end
end
