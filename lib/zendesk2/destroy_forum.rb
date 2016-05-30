# frozen_string_literal: true
class Zendesk2::DestroyForum
  include Zendesk2::Request

  request_method :delete
  request_path do |r| "/forums/#{r.forum_id}.json" end

  def forum_id
    params.fetch('forum').fetch('id')
  end

  def mock
    delete!(:forums, forum_id)

    mock_response(nil)
  end
end
