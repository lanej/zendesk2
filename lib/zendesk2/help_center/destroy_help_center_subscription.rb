# frozen_string_literal: true
class Zendesk2::DestroyHelpCenterSubscription
  include Zendesk2::Request
  include Zendesk2::HelpCenter::SubscriptionRequest

  request_method :delete
  request_path do |r|
    route = "/#{r.route_prefix}/#{r.plural_content_type}/#{r.content_id}"
    route + "/subscriptions/#{r.subscription_id}.json"
  end

  def mock
    content_collection = "help_center_#{plural_content_type}".to_sym
    find!(content_collection, content_id)

    delete!(:help_center_subscriptions, subscription_id)

    mock_response(nil, status: 204)
  end
end
