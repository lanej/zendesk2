class Zendesk2::UpdateUser < Zendesk2::Request
  request_method :put
  request_path { |r| "/users/#{r.user_id}.json" }
  request_body { |r| {"user" => r.user_params } }

  def user_params
    @_user_params ||= Cistern::Hash.slice(params.fetch("user"), *Zendesk2::CreateUser.accepted_attributes)
  end

  def user_id
    @_user_id ||= params.fetch("user").fetch("id").to_i
  end

  def mock
    email = user_params["email"]

    other_users = service.data[:users].dup
    other_users.delete(user_id)

    external_id = user_params["external_id"]

    if external_id && other_users.values.find { |o| o["external_id"].to_s.downcase == external_id.to_s.downcase }
      error!(:invalid, details: {"name" => [ { "description" => "External has already been taken" } ]})
    end

    existing_identity = service.data[:identities].values.find { |i| i["type"] == "email" && i["value"] == email }

    if !email
      # nvm
    elsif existing_identity && existing_identity["user_id"] != user_id
      # email not allowed to conflict across users
      error!(:invalid, details: { "email" => [ {
        "description" => "Email #{params["email"]} is already being used by another user",
      } ] })
    elsif existing_identity && existing_identity["user_id"] == user_id
      # no-op email already used
    else
      # add a new identity
      user_identity_id = service.serial_id

      user_identity = {
        "id"         => user_identity_id,
        "url"        => url_for("/users/#{user_id}/identities/#{user_identity_id}.json"),
        "created_at" => Time.now.iso8601,
        "updated_at" => Time.now.iso8601,
        "type"       => "email",
        "value"      => email,
        "verified"   => false,
        "primary"    => false,
        "user_id"    => user_id,
      }

      service.data[:identities][user_identity_id] = user_identity
    end

    mock_response("user" => self.find!(:users, user_id).merge!(user_params))
  end
end
