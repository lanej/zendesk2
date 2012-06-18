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
      if body = self.data[:tickets][id]

        response(
          :path  => "/tickets/#{id}.json",
          :body  => {
            "ticket" => body
          },
        )
      else 
        r = response(
          :path   => "/tickets/#{id}.json",
          :status => 404
        )
        raise not_found!(nil, r)
      end
    end
  end # Mock
end
