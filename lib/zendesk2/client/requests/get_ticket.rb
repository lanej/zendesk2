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

      if body = self.data[:tickets][id]
        response(
          :path => path,
          :body => {
            "ticket" => body
          },
        )
      else 
        response(
          :path   => path,
          :status => 404,
          :body => {"error" => "RecordNotFound", "description" => "Not found"},
        )
      end
    end
  end # Mock
end
