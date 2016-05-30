# frozen_string_literal: true
class Zendesk2::DestroyUserIdentity
  include Zendesk2::Request

  request_path do |r| "/users/#{r.user_id}/identities/#{r.user_identity_id}.json" end
  request_method :delete

  def user_id
    params.fetch('user_identity').fetch('user_id')
  end

  def user_identity_id
    params.fetch('user_identity').fetch('id')
  end

  def mock
    mock_response('identity' => delete!(:identities, user_identity_id))
  end
end
