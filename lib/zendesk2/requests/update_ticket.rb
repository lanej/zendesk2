class Zendesk2::UpdateTicket < Zendesk2::Request
  request_method :put
  request_path { |r| "/tickets/#{r.ticket_id}.json"  }
  request_body { |r| { "ticket" => r.ticket_params } }

  def self.accepted_attributes
    Zendesk2::CreateTicket.accepted_attributes + ["comment"]
  end

  def ticket_params
    @_ticket_params ||= Cistern::Hash.slice(params.fetch("ticket"), *self.class.accepted_attributes)
  end

  def ticket_id
    params.fetch("ticket").fetch("id")
  end

  def mock
    comment = params.fetch("ticket").delete("comment")

    body = self.find!(:tickets, ticket_id).merge!(ticket_params)

    if comment
      comment_id = service.serial_id

      comment_data = service.data[:ticket_comments][comment_id] = {
        "id"          => comment_id,
        "type"        => "Comment",
        "author_id"   => service.current_user["id"],
        "body"        => comment["body"],
        "html_body"   => "<p>#{comment["body"]}</p>",
        "public"      => comment["public"].nil? ? true : comment["public"],
        "trusted"     => comment["trusted"].nil? ? true : comment["trusted"],
        "attachments" => comment["attachments"] || [],
        "ticket_id"   => ticket_id,
      }

      audit_id = service.serial_id

      audit = {
        "id"         => audit_id,
        "ticket_id"  => ticket_id,
        "created_at" => Time.now,
        "author_id"  => service.current_user["id"],
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
            "client"     => Zendesk2::USER_AGENT,
            "ip_address" => "127.0.0.1",
            "location"   => "Oakland, CA, United States",
            "latitude"   => 37.83449999999999,
            "longitude"  => -122.2647,
          },
          "custom" => {},
        },
        "events" => [comment_data]
      }

      self.data[:ticket_audits][audit_id] = audit
    end

    mock_response(
      "ticket" => body,
      "audit"  => audit,
    )
  end
end
