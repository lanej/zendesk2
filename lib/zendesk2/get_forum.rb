# frozen_string_literal: true
class Zendesk2::GetForum
  include Zendesk2::Request

  request_method :get
  request_path do |r| "/forums/#{r.forum_id}.json" end

  def forum_id
    params.fetch('forum').fetch('id')
  end

  def mock
    mock_response(
      'forum' => find!(:forums, forum_id)
    )
  end
end
