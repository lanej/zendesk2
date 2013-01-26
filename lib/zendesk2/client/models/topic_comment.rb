class Zendesk2::Client::TopicComment < Zendesk2::Model
  extend Zendesk2::Attributes

  PARAMS = %w[id topic_id user_id body informative]

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

    connection.destroy_topic_comment("id" => self.identity, "topic_id" => self.topic_id)
  end

  def save!
    data = if new_record?
             requires :topic_id, :user_id, :body
             connection.create_topic_comment(params).body["topic_comment"]
           else
             requires :identity
             connection.update_topic_comment(params).body["topic_comment"]
           end
    merge_attributes(data)
  end

  def reload
    requires :identity

    if data = self.connection.topic_comments("topic_id" => topic_id).get(identity)
      new_attributes = data.attributes
      merge_attributes(new_attributes)
      self
    end
  end

  private

  def params
    Cistern::Hash.slice(Zendesk2.stringify_keys(attributes), *PARAMS)
  end
end
