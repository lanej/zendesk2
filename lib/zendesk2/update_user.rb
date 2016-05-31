# frozen_string_literal: true
class Zendesk2::UpdateUser
  include Zendesk2::Request

  request_method :put
  request_path do |r| "/users/#{r.user_id}.json" end
  request_body do |r| { 'user' => r.user_params } end

  def user_params
    Cistern::Hash.slice(params.fetch('user'), *Zendesk2::CreateUser.accepted_attributes)
  end

  def user_id
    @_user_id ||= params.fetch('user').fetch('id').to_i
  end

  def mock
    update_params = user_params

    email = update_params['email']

    other_users = cistern.data[:users].dup
    other_users.delete(user_id)

    external_id = update_params['external_id']

    if external_id && other_users.values.find { |o| o['external_id'].to_s.casecmp(external_id.to_s.downcase).zero? }
      error!(:invalid, details: { 'name' => [{ 'description' => 'External has already been taken' }] })
    end

    existing_identity = cistern.data[:identities].values.find { |i| i['type'] == 'email' && i['value'] == email }

    if !email
      # nvm
    elsif existing_identity
      # email not allowed to conflict across users
      existing_identity['user_id'] != user_id &&
        error!(:invalid, details: { 'email' => [{
                 'description' => "Email #{params['email']} is already being used by another user",
               },], })
    else
      add_user_identity(email)
    end

    mock_response('user' => find!(:users, user_id).merge!(update_params))
  end

  private

  def add_user_identity(email)
    # add a new identity
    user_identity_id = cistern.serial_id

    user_identity = {
      'id'         => user_identity_id,
      'url'        => url_for("/users/#{user_id}/identities/#{user_identity_id}.json"),
      'created_at' => Time.now.iso8601,
      'updated_at' => Time.now.iso8601,
      'type'       => 'email',
      'value'      => email,
      'verified'   => false,
      'primary'    => false,
      'user_id'    => user_id,
    }

    cistern.data[:identities][user_identity_id] = user_identity
  end
end
