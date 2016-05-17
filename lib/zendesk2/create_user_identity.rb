class Zendesk2::CreateUserIdentity < Zendesk2::Request
  request_method :post
  request_path { |r| "/users/#{r.user_id}/identities.json" }
  request_body { |r| { "identity" => r.user_identity_params } }

  def self.accepted_attributes
    %w[primary verified type value user_id]
  end

  def user_identity_params
    Cistern::Hash.slice(params.fetch("user_identity"), *self.class.accepted_attributes)
  end

  def user_id
    params.fetch("user_identity").fetch("user_id").to_i
  end

  def mock
    identity = service.serial_id

    record = {
      "id"         => identity,
      "url"        => url_for("/user/#{user_id}/identities/#{identity}.json"),
      "created_at" => Time.now.iso8601,
      "updated_at" => Time.now.iso8601,
      "verified"   => false,
      "primary"    => false,
      "user_id"    => user_id,
    }.merge(user_identity_params)

    record.merge("primary" => true) if service.data[:identities].values.find { |ui| ui["user_id"] == user_id }.nil?

    if service.data[:identities].values.find { |i| i["value"] == record["value"] }
      error!(:invalid, details: { "value" => [ { "description" => "Value: #{record["value"]} is already being used by another user" } ] })
    end

    service.data[:identities][identity] = record

    mock_response("identity" => record)
  end
end
