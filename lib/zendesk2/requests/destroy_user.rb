class Zendesk2::DestroyUser < Zendesk2::Request
  request_method :delete
  request_path { |r| "/users/#{r.user_id}.json" }

  def user_id
    @_user_id ||= params.fetch("user").fetch("id").to_i
  end

  def mock
    ticket_count = service.data[:tickets].values.select { |t| t["requester_id"].to_i == user_id }.size

    if ticket_count < 1
      service.data[:identities].each { |k,v| service.data[:identities].delete(k) if v["user_id"] == user_id }

      mock_response("user" => self.delete!(:users, user_id))
    else
      error!(:invalid, "details" => {
        "base" => [{
          "type"        => "User is requester on #{ticket_count} ticket(s) that are not closed.",
          "description" => "Base User is requester on #{ticket_count} ticket(s) that are not closed."
        }]
      })
    end
  end
end
