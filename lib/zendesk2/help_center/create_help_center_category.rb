# frozen_string_literal: true
class Zendesk2::CreateHelpCenterCategory
  include Zendesk2::Request

  request_method :post
  request_path { |_| '/help_center/categories.json' }
  request_body { |r| { 'category' => r.category_params } }

  def self.accepted_attributes
    %w(category_id description locale name position sorting)
  end

  def category_params
    Cistern::Hash.slice(params.fetch('category'), *self.class.accepted_attributes)
  end

  def mock
    identity = cistern.serial_id

    locale = params['locale'] ||= 'en-us'
    position = data[:help_center_categories].size

    record = {
      'id'          => identity,
      'url'         => url_for("/help_center/#{locale}/categories/#{identity}.json"),
      'html_url'    => html_url_for("/hc/#{locale}/categories/#{identity}.json"),
      'author_id'   => cistern.current_user['id'],
      'position'    => position,
      'created_at'  => timestamp,
      'updated_at'  => timestamp,
      'description' => '',
    }.merge(category_params)

    data[:help_center_categories][identity] = record

    mock_response('category' => record)
  end
end
