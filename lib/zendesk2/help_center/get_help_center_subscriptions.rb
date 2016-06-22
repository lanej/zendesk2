# frozen_string_literal: true
class Zendesk2::GetHelpCenterSubscriptions
  include Zendesk2::Request
  include Zendesk2::HelpCenter::SubscriptionRequest

  request_path { |r| "/#{r.route_prefix}/#{r.plural_content_type}/#{r.content_id}/subscriptions.json" }

  def mock
    article_subscriptions = cistern.data[:help_center_subscriptions].values.select do |sub|
      sub['content_id'] == content_id
    end
    resources(article_subscriptions, root: 'subscriptions')
  end
end
