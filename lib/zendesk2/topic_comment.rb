# frozen_string_literal: true
class Zendesk2::TopicComment
  include Zendesk2::Model

  extend Zendesk2::Attributes

  # @return [Integer] Automatically assigned upon creation
  identity :id, type: :integer

  # @return [Array] Attachments to this comment as Attachment objects
  attribute :attachments, type: :array
  # @return [String] The comment body
  attribute :body, type: :string
  # @return [Time] The time the topic_comment was created
  attribute :created_at, type: :time
  # @return [Boolean] If the comment has been flagged as informative
  attribute :informative, type: :boolean
  # @return [Integer] The id of the topic this comment was made on
  attribute :topic_id, type: :integer
  # @return [Time] The time of the last update of the topic_comment
  attribute :updated_at, type: :time
  # @return [String] The API url of this topic comment
  attribute :url, type: :string
  # @return [Integer] The id of the user making the topic comment
  attribute :user_id, type: :integer

  assoc_accessor :user
  assoc_accessor :topic

  def destroy!
    requires :identity

    cistern.destroy_topic_comment('topic_comment' => { 'id' => identity, 'topic_id' => topic_id })
  end

  def save!
    response = if new_record?
                 requires :topic_id, :user_id, :body

                 cistern.create_topic_comment('topic_comment' => attributes)
               else
                 requires :identity

                 cistern.update_topic_comment('topic_comment' => attributes)
               end

    merge_attributes(response.body['topic_comment'])
  end

  def reload
    requires :identity

    data = cistern.topic_comments('topic_id' => topic_id).get(identity)

    return unless data

    new_attributes = data.attributes
    merge_attributes(new_attributes)
    self
  end
end
