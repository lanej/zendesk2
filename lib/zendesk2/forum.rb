# frozen_string_literal: true
class Zendesk2::Forum
  include Zendesk2::Model

  extend Zendesk2::Attributes

  # @return [Fixnum] Automatically assigned upon creation
  identity :id, type: :integer # ro: yes, required: no

  # @return [String] The API url of this forum
  attribute :url, type: :string # ro: yes, required: no
  # @return [String] The name of the forum
  attribute :name, type: :string # ro: no, required: yes
  # @return [String] A description of the forum
  attribute :description, type: :string # ro: no, required: no
  # @return [Fixnum] Category this forum is in
  attribute :category_id, type: :integer # ro: no, required: no
  # @return [Fixnum] Organization this forum is restricted to
  attribute :organization_id, type: :integer # ro: no, required: no
  # @return [Fixnum] User locale id this forum is restricted to
  attribute :locale_id, type: :integer # ro: no, required: no
  # @return [Boolean] Whether this forum is locked such that new entries and comments cannot be made
  attribute :locked, type: :boolean # ro: no, required: no
  # @return [Fixnum] Contains the number of unanswered questions if this forum's topics are questions.
  attribute :unanswered_topics, type: :integer # ro: yes, required: no
  # @return [Fixnum] The position of this forum relative to other forums in the same category
  attribute :position, type: :integer # ro: no, required: no
  # @return [String] The type of the topics in this forum, valid values: "articles", "ideas" or "questions"
  attribute :forum_type, type: :string # ro: no, required: no
  # @return [String] Who has access to this forum, valid values: "everybody", "logged-in users" or "agents only"
  attribute :access, type: :string # ro: no, required: no
  # @return [Array] Restrict access to end-users and organizations with all these tags
  attribute :tags, type: :array # ro: no, required: no
  # @return [Time] The time the forum was created
  attribute :created_at, type: :time # ro: yes, required: no
  # @return [Time] The time of the last update of the forum
  attribute :updated_at, type: :time # ro: yes, required: no

  assoc_accessor :organization
  assoc_accessor :category

  def destroy!
    requires :identity

    cistern.destroy_forum('forum' => { 'id' => identity })
  end

  def save!
    response = if new_record?
                 requires :name

                 cistern.create_forum('forum' => attributes)
               else
                 requires :identity

                 cistern.update_forum('forum' => attributes)
               end

    merge_attributes(response.body['forum'])
  end
end
