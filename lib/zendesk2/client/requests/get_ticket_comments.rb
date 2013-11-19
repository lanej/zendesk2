class Zendesk2::Client
  class Real
    def get_ticket_comments(params={})
      ticket_id = params["ticket_id"]
      request(
        :method => :get,
        :path => "/tickets/#{ticket_id}/comments.json"
      )
    end
  end # Real

  class Mock
    def get_ticket_comments(params={})
      ticket_id = params["ticket_id"]

      page(params,
           :ticket_comments,
           "/tickets/#{ticket_id}/comments.json",
           "comments")
    end
  end # Mock
end
