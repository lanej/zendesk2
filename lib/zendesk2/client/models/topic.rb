class Zendesk2::Client::Topic < Zendesk2::Model
  extend Zendesk2::Attributes

  PARAMS = %w[id title body submitter_id updater_id forum_id locked pinned highlighted position tags]

  identity  :id,           type: :integer # ro[yes] mandatory[no]   Automatically assigned upon creation
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
  attribute :created_at,   type: :date    # ro[yes] mandatory[no] The time the topic was created

  assoc_accessor :submitter, collection: :users
  assoc_accessor :updater, collection: :users
  assoc_accessor :forum


  def destroy!
    requires :identity

    connection.destroy_topic("id" => self.identity)
  end

  def save!
    data = if new_record?
             requires :title, :body
             connection.create_topic(params).body["topic"]
           else
             requires :identity
             connection.update_topic(params).body["topic"]
           end
    merge_attributes(data)
  end

  def comments
    self.topic_comments(topic_id: topic_id)
  end

  private

  def params
    Cistern::Hash.slice(Zendesk2.stringify_keys(attributes), *PARAMS)
  end
end
