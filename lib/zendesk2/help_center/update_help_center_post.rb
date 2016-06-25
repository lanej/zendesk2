# frozen_string_literal: true
class Zendesk2::UpdateHelpCenterPost
  include Zendesk2::Request

  request_method :put
  request_body { |r| { 'post' => r.post_params } }
  request_path { |r| "/community/posts/#{r.post_id}.json" }

  def post_params
    Cistern::Hash.slice(params.fetch('post'), *Zendesk2::CreateHelpCenterPost.accepted_attributes)
  end

  def post_id
    params.fetch('post').fetch('id')
  end

  def mock
    mock_response('post' => find!(:help_center_categories, post_id).merge!(post_params))
  end
end
