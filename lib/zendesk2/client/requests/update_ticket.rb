class Zendesk2::Client
  class Real
    def update_ticket(params={})
      id = params.delete("id")

      request(
        :method => :put,
        :path   => "/tickets/#{id}.json",
        :body   => {
          "ticket" => params
        },
      )
    end
  end
  class Mock
    def update_ticket(params={})
      ticket_id = params.delete("id")
      body      = self.data[:tickets][ticket_id].merge!(params)

      if comment = params["comment"]
        audit_id = self.class.new_id
        self.data[:ticket_audits][audit_id] = {
          "id"         => audit_id,
          "ticket_id"  => ticket_id,
          "created_at" => Time.now,
          "author_id"  => current_user["id"],
          "via"        => {
            "channel" => "api",
            "source"  => {
              "form" => {},
              "to"   => {},
              "rel"  => nil,
            }
          },
          "metadata" => {
            "system" => {
              "client"     => Zendesk2::Client::USER_AGENT,
              "ip_address" => "127.0.0.1",
              "location"   => "Oakland, CA, United States",
              "latitude"   => 37.83449999999999,
              "longitude"  => -122.2647,
            },
            "custom" => {},
          },
          "events" => [
            "id"          => self.class.new_id,
            "type"        => "Comment",
            "author_id"   => current_user["id"],
            "body"        => comment["body"],
            "html_body"   => "<p>#{comment["body"]}</p>",
            "public"      => comment["public"].nil? ? true : comment["public"],
            "trusted"     => comment["trusted"].nil? ? true : comment["trusted"],
            "attachments" => comment["attachments"] || [],
          ]
        }
      end

      response(
        :method => :put,
        :path   => "/tickets/#{ticket_id}.json",
        :body   => {
          "ticket" => body
        },
      )
    end
  end
end
