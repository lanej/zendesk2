# frozen_string_literal: true
class Zendesk2::UpdateUserIdentity
  include Zendesk2::Request

  request_path do |r| "/users/#{r.user_id}/identities/#{r.user_identity_id}.json" end
  request_method :put
  request_body do |r| { 'identity' => r.user_identity_params } end

  def self.accepted_attributes
    %w(verified)
  end

  def user_id
    params.fetch('user_identity').fetch('user_id')
  end

  def user_identity_id
    params.fetch('user_identity').fetch('id')
  end

  def user_identity_params
    Cistern::Hash.slice(params.fetch('user_identity'), *self.class.accepted_attributes)
  end

  def mock
    mock_response('identity' => find!(:identities, user_identity_id).merge!(user_identity_params))
  end
end
