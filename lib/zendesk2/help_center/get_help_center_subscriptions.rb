# frozen_string_literal: true
class Zendesk2::GetHelpCenterSubscriptions
  include Zendesk2::Request

  request_path { |r| "help_center/#{r.plural_content_type}/#{r.content_id}/subscriptions.json" }

  def plural_content_type
    pluralize(content_type)
  end

  def content_type
    subscription.fetch('content_type')
  end

  def content_id
    subscription.fetch('content_id')
  end

  def subscription
    params.fetch('subscription')
  end

  def mock
    article_subscriptions = cistern.data[:help_center_subscriptions].values.select do |sub|
      sub['content_id'] == content_id
    end
    resources(article_subscriptions, root: 'subscriptions')
  end
end
