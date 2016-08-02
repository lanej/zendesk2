# frozen_string_literal: true
class Zendesk2::CreateHelpCenterSubscription
  include Zendesk2::Request
  include Zendesk2::HelpCenter::SubscriptionRequest

  request_method :post
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
    identity = cistern.serial_id

    url = url_for("/help_center/#{plural_content_type}/#{content_id}/subscription.json")

    content_collection = "help_center_#{plural_content_type}".to_sym
    find!(content_collection, content_id)

    if subscription_params.empty?
      mock_response('Required parameter missing: subscription', status: 400)
    end

    record = subscription_params.merge(
      'id'           => identity,
      'url'          => url,
      'created_at'   => timestamp, # @todo create #timestamp helper
      'updated_at'   => timestamp,
      'content_id'   => content_id,
      'content_type' => content_type,
    )

    record['locale'] = record.delete('source_locale') if record['source_locale']

    cistern.data[:help_center_subscriptions][identity] = record

    mock_response('subscription' => record)
  end
end
