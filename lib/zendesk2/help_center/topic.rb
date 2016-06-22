# frozen_string_literal: true
class Zendesk2::HelpCenter::Topic
  include Zendesk2::Model

  extend Zendesk2::Attributes

  # Automatically assigned when the topic is created
  identity :id, type: :integer

  # API url of the topic
  attribute :url
  # The community url of the topic
  attribute :html_url
  # The name of the topic
  attribute :name
  # By default an empty string
  attribute :description
  # The position of the topic relative to other topics in the community
  attribute :position, type: :integer
  # The number of users following the topic
  attribute :follower_count, type: :integer
  # When the topic was created
  attribute :created_at, type: :time
  # When the topic was last updated
  attribute :updated_at, type: :time

  def destroy!
    requires :identity

    cistern.destroy_help_center_topic('topic' => { 'id' => identity })
  end

  def save!
    response = if new_record?
                 requires :name

                 cistern.create_help_center_topic('topic' => attributes)
               else
                 requires :identity

                 cistern.update_help_center_topic('topic' => attributes)
               end

    merge_attributes(response.body['topic'])
  end
end
