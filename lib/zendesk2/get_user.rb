# frozen_string_literal: true
class Zendesk2::GetUser
  include Zendesk2::Request

  request_method :get
  request_path do |r| "/users/#{r.user_id}.json" end

  def user_id
    params.fetch('user').fetch('id').to_i
  end

  def mock
    identities = data[:identities].values.select { |i| i['user_id'] == user_id }
    body = find!(:users, user_id).dup
    identity = identities.find { |i| i['type'] == 'email' && i['primary'] } ||
               identities.find { |i| i['type'] == 'email' }
    body['email'] = identity['value'] if identity

    # @todo what happens if no identity?

    mock_response('user' => body)
  end
end
