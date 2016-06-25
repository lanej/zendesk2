# frozen_string_literal: true
class Zendesk2::GetHelpCenterPosts
  include Zendesk2::Request

  request_path do |r|
    if r.topic_id
      "/community/topics/#{r.topic_id}.json"
    elsif r.user_id
      "/community/users/#{r.user_id}.json"
    else
      '/community/posts.json'
    end
  end

  page_params!

  def topic_id
    params['topic_id']
  end

  def user_id
    params['user_id']
  end

  def mock
    page(:help_center_posts, root: 'posts')
  end
end
