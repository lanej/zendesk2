# frozen_string_literal: true
class Zendesk2::CreateHelpCenterPost
  include Zendesk2::Request

  request_method :post
  request_path { |_| '/community/posts.json' }
  request_body { |r| { 'post' => r.post_params } }

  def self.accepted_attributes
    %w(title details author_id topic_id pinned featured closed status created_at)
  end

  def post_params
    Cistern::Hash.slice(params.fetch('post'), *self.class.accepted_attributes)
  end

  def mock
    identity = cistern.serial_id

    record = {
      'id'             => identity,
      'url'            => url_for("/community/posts/#{identity}.json"),
      'html_url'       => html_url_for("/hc/posts/#{identity}.json"),
      'created_at'     => timestamp,
      'updated_at'     => timestamp,
      'vote_count'     => 0,
      'vote_sum'       => 0,
      'comment_count'  => 0,
      'follower_count' => 0,
      'details'        => '',
    }.merge(post_params)

    data[:help_center_posts][identity] = record

    mock_response('post' => record)
  end
end
