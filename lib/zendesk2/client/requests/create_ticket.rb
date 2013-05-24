class Zendesk2::Client
  class Real
    def create_ticket(params={})
      request(
        :body   => {"ticket" => params},
        :method => :post,
        :path   => "/tickets.json",
      )
    end
  end # Real

  class Mock
    def create_ticket(params={})
      identity = self.class.new_id

      if requester = params.delete('requester')
        user_id = if known_user = self.users.search(email: requester['email']).first
                    known_user.identity
                  else
                    # name is not required in this case
                    create_user(requester).body["user"]["id"]
                  end

        params['requester_id'] = user_id
      end

      record = {
        "id"               => identity,
        "url"              => url_for("/tickets/#{identity}.json"),
        "created_at"       => Time.now.iso8601,
        "updated_at"       => Time.now.iso8601,
        "collaborator_ids" => [],
      }.merge(params)

      record["requester_id"] ||= current_user["id"]
      record["submitter_id"] = current_user["id"]

      # FIXME: throw error if user doesn't exist?
      requester = self.data[:users][record["requester_id"]]
      record["organization_id"] = requester["organization_id"]

      self.data[:tickets][identity] = record

      response(
        :method => :post,
        :body   => {"ticket" => record},
        :path   => "/tickets.json"
      )
    end
  end # Mock
end # Zendesk2::Client
