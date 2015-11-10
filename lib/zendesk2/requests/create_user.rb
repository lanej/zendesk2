class Zendesk2::CreateUser < Zendesk2::Request
  request_method :post
  request_path { |_| "/users.json" }
  request_body { |r| { "user" => r.user_params } }

  def self.accepted_attributes
    %w[name email organization_id external_id alias verified locate_id time_zone phone signature details notes role custom_role_id moderator ticket_restriction only_private_comments user_fields]
  end

  def user_params
    Cistern::Hash.slice(params.fetch("user"), *self.class.accepted_attributes)
  end

  def mock
    user_id = service.serial_id

    user = params.fetch("user")

    if organization_id = user["organization_id"]
      self.find!(:organizations, organization_id)
    end

    record = {
      "id"         => user_id,
      "url"        => url_for("/users/#{user_id}.json"),
      "created_at" => Time.now.iso8601,
      "updated_at" => Time.now.iso8601,
      "role"       => "end-user",
      "active"     => true,
    }.merge(user_params)

    if record["external_id"] && self.data[:users].values.find { |o| o["external_id"].to_s.downcase == record["external_id"].to_s.downcase }
      error!(:invalid, details: {"name" => [ { "description" => "External has already been taken" } ]})
    end

    if (email = record["email"]) && self.data[:identities].find { |k,i| i["type"] == "email" && i["value"].to_s.downcase == email.downcase }
      error!(:invalid, :details => {
        "email" => [ {
          "description" => "Email: #{email} is already being used by another user"
        }]})
    else
      user_identity_id = service.serial_id

      user_identity = {
        "id"         => user_identity_id,
        "url"        => url_for("/users/#{user_id}/identities/#{user_identity_id}.json"),
        "created_at" => Time.now.iso8601,
        "updated_at" => Time.now.iso8601,
        "type"       => "email",
        "value"      => record["email"],
        "verified"   => false,
        "primary"    => true,
        "user_id"    => user_id,
      }

      self.data[:identities][user_identity_id] = user_identity
      self.data[:users][user_id] = record.reject { |k,v| k == "email" }

      if organization_id
        service.create_membership("membership" => { "user_id" => user_id, "organization_id" => organization_id, "default" => true } )
      end

      mock_response({"user" => record}, {status: 201})
    end
  end
end
