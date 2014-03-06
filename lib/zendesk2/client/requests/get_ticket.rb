class Zendesk2::Client
  class Real
    def get_ticket(params={})
      id = params["id"]

      request(
        :method => :get,
        :path => "/tickets/#{id}.json"
      )
    end
  end # Real

  class Mock
    def get_ticket(params={})
      id   = params["id"]
      path = "/tickets/#{id}.json"

      response(
        :path => path,
        :body => {
          "ticket" => self.find!(:tickets, id)
        },
      )
    end
  end # Mock
end
