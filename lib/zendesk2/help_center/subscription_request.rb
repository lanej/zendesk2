# frozen_string_literal: true
module Zendesk2::HelpCenter::SubscriptionRequest
  def route_prefix
    content_type == 'topic' ? 'community' : 'help_center'
  end

  def plural_content_type
    pluralize(content_type)
  end

  def content_type
    subscription.fetch('content_type')
  end

  def content_id
    subscription.fetch('content_id').to_i
  end

  def subscription_id
    subscription.fetch('id')
  end

  def subscription
    Cistern::Hash.stringify_keys(params.fetch('subscription'))
  end
end
