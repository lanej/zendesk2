# frozen_string_literal: true
class Zendesk2::CreateUser
  include Zendesk2::Request

  request_method :post
  request_path { |_| '/users.json' }
  request_body { |r| { 'user' => r.user_params } }

  def self.accepted_attributes
    %w(name email organization_id external_id alias verified locate_id time_zone phone signature details notes role
       custom_role_id moderator ticket_restriction only_private_comments user_fields)
  end

  def user_params
    Cistern::Hash.slice(params.fetch('user'), *self.class.accepted_attributes)
  end

  def mock
    user_id = cistern.serial_id

    user = params.fetch('user')
    organization_id = user['organization_id']
    organization_id && find!(:organizations, organization_id)

    record = {
      'id'         => user_id,
      'url'        => url_for("/users/#{user_id}.json"),
      'created_at' => timestamp,
      'updated_at' => timestamp,
      'role'       => 'end-user',
      'active'     => true,
    }.merge(user_params)

    external_id = record['external_id']
    matching_external_id = external_id && data[:users].values.find do |o|
      o['external_id'].to_s.casecmp(external_id.to_s.downcase).zero?
    end

    if matching_external_id
      error!(:invalid, details: { 'name' => [{ 'description' => 'External has already been taken' }] })
    end

    email = record['email']
    matching_identity = email && data[:identities].values.find do |i|
      i['type'] == 'email' && i['value'].to_s.casecmp(email.downcase).zero?
    end

    if matching_identity
      error!(:invalid, details: {
               'email' => [{
                 'description' => "Email: #{email} is already being used by another user",
               },],
             })
    end

    user_identity_id = cistern.serial_id

    user_identity = {
      'id'         => user_identity_id,
      'url'        => url_for("/users/#{user_id}/identities/#{user_identity_id}.json"),
      'created_at' => timestamp,
      'updated_at' => timestamp,
      'type'       => 'email',
      'value'      => record['email'],
      'verified'   => false,
      'primary'    => true,
      'user_id'    => user_id,
    }

    data[:identities][user_identity_id] = user_identity
    data[:users][user_id] = record.reject { |k, _v| k == 'email' }

    if organization_id
      cistern.create_membership(
        'membership' => { 'user_id' => user_id, 'organization_id' => organization_id, 'default' => true }
      )
    end

    mock_response({ 'user' => record }, { status: 201 })
  end
end
