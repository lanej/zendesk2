# frozen_string_literal: true
class Zendesk2::UpdateHelpCenterSubscription
  include Zendesk2::Request
  include Zendesk2::HelpCenter::SubscriptionRequest

  request_method :put
  request_path { |r| "/#{r.route_prefix}/#{r.plural_content_type}/#{r.content_id}/subscriptions.json" }
  request_body do |r|
    { 'subscription' => r.subscription_params } if r.subscription_params.any?
  end

  def subscription_params
    return @subscription_params if @subscription_params
    body = Cistern::Hash.slice(subscription, *self.class.accepted_attributes(content_type))
    body['source_locale'] = body.delete('locale') if body['locale']
    @subscription_params = body
  end

  def mock
    subscription = find!(:help_center_subscriptions, subscription_id)

    if subscription_params.empty?
      mock_response('Required parameter missing: subscription', status: 400)
    end

    updated = subscription_params
    updated['locale'] = updated.delete('source_locale') if updated['source_locale']
    updated['updated_at'] = timestamp

    subscription.merge!(updated)

    mock_response('subscription' => subscription)
  end
end
