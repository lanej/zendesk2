# frozen_string_literal: true
class Zendesk2::GetHelpCenterPost
  include Zendesk2::Request

  request_method :get
  request_path { |r| "/community/posts/#{r.post_id}.json" }

  def post_id
    post.fetch('id')
  end

  def post
    Cistern::Hash.stringify_keys(params.fetch('post'))
  end

  def mock
    mock_response('post' => find!(:help_center_posts, post_id))
  end
end
