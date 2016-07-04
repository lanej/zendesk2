# frozen_string_literal: true
class Zendesk2::GetUsersHelpCenterSubscriptions
  include Zendesk2::Request

  request_path { |r| "/help_center/users/#{r.user_id}/subscriptions.json" }

  page_params!

  def user_id
    params.fetch('user_id').to_i
  end

  def mock
    article_subscriptions = cistern.data[:help_center_subscriptions].values.select do |sub|
      sub['user_id'] == user_id
    end

    page(article_subscriptions, root: 'subscriptions')
  end
end
