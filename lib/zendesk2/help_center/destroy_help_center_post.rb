# frozen_string_literal: true
class Zendesk2::DestroyHelpCenterPost
  include Zendesk2::Request

  request_path { |r| "/community/posts/#{r.post_id}.json" }
  request_method :delete

  def post_id
    params.fetch('post').fetch('id')
  end

  def mock
    mock_response('post' => delete!(:help_center_posts, post_id))
  end
end
