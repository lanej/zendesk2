# frozen_string_literal: true
class Zendesk2::HelpCenter::Subscription
  include Zendesk2::Model

  extend Zendesk2::Attributes

  # @return [Integer] Automatically assigned when the subscription is created
  identity :id, type: :integer # ro: yes, required: no

  # @return [String] The API url of the subscription
  attribute :url # ro: yes, required: no
  # @return [Integer] The id of the user who has this subscription
  attribute :user_id, type: :integer # ro: yes, required: no
  # @return [Integer] The id of the subscribed item
  attribute :content_id, type: :integer # ro: yes, required: no
  # @return [String] The type of the subscribed item
  attribute :content_type # ro: yes, required: no
  # @return [String] The locale of the subscribed item
  attribute :locale # ro: yes, required: yes
  # @return [Boolean] Subscribe also to article comments. Only for section subscriptions.
  attribute :include_comments, type: :boolean # ro: yes, required: no
  # @return [Time] The time at which the subscription was created
  attribute :created_at, type: :time # ro: yes, required: no
  # @return [Time] The time at which the subscription was last updated
  attribute :updated_at, type: :time # ro: yes, required: no

  def destroy!
    requires :identity

    cistern.destroy_help_center_subscription('subscription' => attributes)
  end

  def save!
    response = if new_record?
                 requires :content_id, :content_type

                 cistern.create_help_center_subscription('subscription' => attributes)
               else
                 requires :identity

                 cistern.update_help_center_subscription('subscription' => attributes)
               end

    merge_attributes(response.body['subscription'])
  end
end
