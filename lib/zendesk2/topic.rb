# frozen_string_literal: true
class Zendesk2::Topic
  include Zendesk2::Model

  extend Zendesk2::Attributes

  # @return [integer] Automatically assigned upon creation
  identity :id, type: :integer # ro: yes, required: no

  # @return [string] The API url of this topic
  attribute :url, type: :string # ro: yes, required: no
  # @return [string] The title of the topic
  attribute :title, type: :string # ro: no, required: yes
  # @return [string] The unescaped body of the topic
  attribute :body, type: :string # ro: no, required: yes
  # @return [string] The type of topic. Either "articles", "ideas" or "questions"
  attribute :topic_type, type: :string # ro: yes, required: no
  # @return [integer] The id of the user who submitted the topic
  attribute :submitter_id, type: :integer # ro: no, required: no
  # @return [integer] The id of the person to last update the topic
  attribute :updater_id, type: :integer # ro: no, required: no
  # @return [integer] Forum that the topic is associated to
  attribute :forum_id, type: :integer # ro: no, required: no
  # @return [boolean] Whether comments are allowed
  attribute :locked, type: :boolean # ro: no, required: no
  # @return [boolean] If the topic is marked as pinned and hence eligible to show up on the front page
  attribute :pinned, type: :boolean # ro: no, required: no
  # @return [boolean] Set to true to highlight a topic within its forum
  attribute :highlighted, type: :boolean # ro: no, required: no
  # @return [boolean] Set to true if the topic is a question and it has been marked as answered.
  attribute :answered, type: :boolean # ro: yes, required: no
  # @return [integer] The number of comments on this topic
  attribute :comments_count, type: :integer # ro: yes, required: no
  # @return [array] The search phrases set on the topic
  attribute :search_phrases, type: :array # ro: no, required: no
  # @return [integer] The position of this topic relative to other topics in the same forum when the topics are
  #   ordered manually
  attribute :position, type: :integer # ro: no, required: no
  # @return [array] The tags set on the topic
  attribute :tags, type: :array # ro: no, required: no
  # @return [date] The time the topic was created
  attribute :created_at, type: :date # ro: yes, required: no
  # @return [date] The time of the last update of the topic
  attribute :updated_at, type: :date # ro: yes, required: no
  # @return [array] The attachments on this comment as Attachment objects
  attribute :attachments, type: :array # ro: yes, required: no
  # @return [array] List of upload tokens for adding attachments
  attribute :uploads, type: :array # ro: no, required: no

  assoc_accessor :submitter, collection: :users
  assoc_accessor :updater, collection: :users
  assoc_accessor :forum

  def destroy!
    requires :identity

    cistern.destroy_topic('topic' => { 'id' => identity })
  end

  def save!
    data = if new_record?
             requires :title, :body

             cistern.create_topic('topic' => attributes)
           else
             requires :identity

             cistern.update_topic('topic' => attributes)
           end

    merge_attributes(data.body['topic'])
  end

  def comments
    topic_comments(topic_id: topic_id)
  end
end
