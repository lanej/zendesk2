class Zendesk2::GetUser < Zendesk2::Request
  request_method :get
  request_path { |r| "/users/#{r.user_id}.json" }

  def user_id
    params.fetch("user").fetch("id").to_i
  end

  def mock
    identities = self.data[:identities].values.select { |i| i["user_id"] == user_id }
    body = find!(:users, user_id).dup

    if identity = identities.find { |i| i["type"] == "email" && i["primary"] } || identities.find { |i| i["type"] == "email" }
      body.merge!("email" => identity["value"])
    end

    # @todo what happens if no identity?

    mock_response("user" => body)
  end
end
