# frozen_string_literal: true
class Zendesk2::GetHelpCenterSubscription
  include Zendesk2::Request
  include Zendesk2::HelpCenter::SubscriptionRequest

  request_method :get
  request_path do |r|
    content_path = "/#{r.route_prefix}/#{r.plural_content_type}"
    content_path + "/#{r.content_id}/subscriptions/#{r.subscription_id}.json"
  end

  def mock(_params = {})
    mock_response('subscription' => find!(:help_center_subscriptions, subscription_id))
  end
end
