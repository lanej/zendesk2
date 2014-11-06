class Zendesk2::Client
  class Real
    def get_ticket_comments(params={})
      ticket_id = require_parameters(params, "ticket_id")

      request(
        :method => :get,
        :path => "/tickets/#{ticket_id}/comments.json"
      )
    end
  end # Real

  class Mock
    def get_ticket_comments(params={})
      ticket_id = require_parameters(params, "ticket_id")

      page(params,
           :ticket_comments,
           "/tickets/#{ticket_id}/comments.json",
           "comments", filter: lambda { |comments| comments.select { |comment| comment["ticket_id"].to_s == ticket_id.to_s } })
    end
  end # Mock
end
