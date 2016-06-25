# frozen_string_literal: true
class Zendesk2::HelpCenter::Post
  include Zendesk2::Model

  extend Zendesk2::Attributes

  # Automatically assigned when the post is created
  identity :id, type: :integer

  # API url of the post
  attribute :url
  # The community url of the post
  attribute :html_url
  # The title of the post
  attribute :title
  # The details of the post
  attribute :details
  # The id of the author of the post. *Writable on create by Help Center managers -- see Create Post
  attribute :author_id, type: :integer
  # When true, pins the post to the top of its topic
  attribute :pinned, type: :boolean
  # Whether the post is featured
  attribute :featured, type: :boolean
  # Whether further comments are allowed
  attribute :closed, type: :boolean
  # Possible values: "planned", "not_planned" , "answered", or "completed"
  attribute :status
  # The total sum of votes on the post
  attribute :vote_sum, type: :integer
  # The number of votes cast on the post
  attribute :vote_count, type: :integer
  # The number of comments on the post
  attribute :comment_count, type: :integer
  # The number of followers of the post
  attribute :follower_count, type: :integer
  # The id of the topic that the post belongs to
  attribute :topic_id, type: :integer
  # Post
  attribute :created_at, type: :time
  # When the post was last updated
  attribute :updated_at, type: :time

  def destroy!
    requires :identity

    cistern.destroy_help_center_post('post' => { 'id' => identity })
  end

  def save!
    response = if new_record?
                 requires :title, :details, :topic_id

                 cistern.create_help_center_post('post' => attributes)
               else
                 raise NotImplementedError
               end

    merge_attributes(response.body['post'])
  end
end
