class Zendesk2::Client
  class Real
    def destroy_user(params={})
      id = params["id"]

      request(
        :method => :delete,
        :path   => "/users/#{id}.json"
      )
    end
  end

  class Mock
    def destroy_user(params={})
      id   = params["id"]
      path = "/users/#{id}.json"

      tickets = self.data[:tickets].values.select{|t| t["requester_id"] == id}.size
      if tickets < 1
        body = self.data[:users].delete(id)
        response(
          :method => :delete,
          :path   => path,
          :body   => {
            "user" => body,
          },
        )
      else
        response(
          :method => :delete,
          :path   => path,
          :status => 422,
          :body   => {
            "error"       => "RecordInvalid",
            "description" => "Record validation errors",
            "details"     => {
              "base" => [{
                "type"        => "User is requester on #{tickets} ticket(s) that are not closed.",
                "description" => "Base User is requester on #{tickets} ticket(s) that are not closed."
              }]
            }
          }
        )
      end
    end
  end
end
