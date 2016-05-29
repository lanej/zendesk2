# frozen_string_literal: true
class Zendesk2::GetHelpCenterSubscription
  include Zendesk2::Request

  request_method :get
  request_path { |r| "help_center/#{r.plural_content_type}/#{r.content_id}/subscriptions/#{r.subscription_id}.json" }

  def plural_content_type
    pluralize(content_type)
  end

  def content_type
    subscription.fetch('content_type')
  end

  def content_id
    subscription.fetch('content_id')
  end

  def subscription_id
    subscription.fetch('id')
  end

  def subscription
    params.fetch('subscription')
  end

  def mock(_params = {})
    mock_response('subscription' => find!(:help_center_subscriptions, subscription_id))
  end
end
