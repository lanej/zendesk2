# frozen_string_literal: true
module Zendesk2::HelpCenter::SubscriptionRequest

  def self.included(klass)
    super
    klass.extend(ClassMethods)
  end

  module ClassMethods
    def accepted_attributes(type)
      case type
      when 'topic'
        %w(include_comments user_id)
      when 'post'
        %w(user_id)
      else
        %w(locale user_id)
      end
    end
  end

  def route_prefix
    case content_type
    when 'topic', 'post'
      'community'
    else
      'help_center'
    end
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
