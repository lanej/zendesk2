class Zendesk2::CreateTicket < Zendesk2::Request
  request_method :post
  request_path { |_| "/tickets.json" }
  request_body { |r| {"ticket" => r.ticket_params} }

  def self.accepted_attributes
    %w[external_id via priority requester requester_id submitter_id assignee_id organization_id subject description custom_fields recipient status collaborator_ids tags]
  end

  def ticket_params
    @_ticket_params ||= Cistern::Hash.slice(params.fetch("ticket"), *self.class.accepted_attributes)
  end

  def mock
    create_params = ticket_params.dup

    if create_params["description"].nil? || create_params["description"] == ""
      error!(:invalid, :details => {"base" => [{"description" => "Description: cannot be blank"}]})
    end

    requester_id = create_params.delete('requester_id')

    if requester = create_params.delete('requester')
      if !requester['name'] || requester['name'].size < 1
        error!(:invalid,
          :details => {
            "requester" => [
              {
                "description" => "Requester Name:  is too short (minimum is 1 characters)"
              }
            ]})
      end

      user_id = if known_user = service.users.search(email: requester['email']).first
                  known_user.identity
                else
                  # name is not required in this case
                  service.create_user("user" => requester).body["user"]["id"]
                end

      create_params['requester_id'] = user_id.to_i
    end

    requested_custom_fields = (create_params.delete("custom_fields") || [])

    custom_fields = requested_custom_fields.map do |cf|
      field_id = cf["id"].to_i

      if service.data[:ticket_fields][field_id]
        {"id" => field_id, "value" => cf["value"] }
      else
        # @fixme error ?!
      end
    end.compact

    service.data[:ticket_fields].each do |field_id, field|
      requested_custom_fields.find { |cf| cf["id"] == field_id } ||
        custom_fields << {"id" => field_id, "value" => nil }
    end

    identity = service.serial_id

    record = {
      "id"               => identity,
      "url"              => url_for("/tickets/#{identity}.json"),
      "created_at"       => Time.now.iso8601,
      "updated_at"       => Time.now.iso8601,
      "priority"         => nil,
      "collaborator_ids" => [],
      "custom_fields"    => custom_fields,
    }.merge(create_params)

    record["requester_id"] ||= (requester_id && requester_id.to_i) || service.current_user["id"]
    record["submitter_id"] = service.current_user["id"].to_i

    record["organization_id"] ||= if requester = service.data[:users][record["requester_id"].to_i]
                                    requester["organization_id"]
                                  end

    service.data[:tickets][identity] = record

    mock_response("ticket" => record)
  end
end
