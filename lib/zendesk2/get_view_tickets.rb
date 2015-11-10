class Zendesk2::GetViewTickets < Zendesk2::Request
  request_method :get
  request_path { |r| "/views/#{r.view_id}/tickets.json" }

  page_params!

  def view_id
    params.fetch("view_id").to_i
  end

  def mock(params={})
    view = self.find!(:views, view_id)

    tickets = Array(view["conditions"]["all"]).map { |c|
      operator = ("is" == c.fetch("operator")) ? :eql? : :!=
      key      = c.fetch("field")
      value    = c.fetch("value").to_s

      [operator, key, value]
    }.inject(self.data[:tickets].values) { |r, (o,k,v)|
      r.select { |t| t[k].to_s.public_send(o, v) }
    }

    any_operators = Array(view["conditions"]["any"]).map { |c|
      operator = ("is" == c.fetch("operator")) ? :eql? : :!=
      key      = c.fetch("field")
      value    = c.fetch("value").to_s

      [operator, key, value]
    }

    any_operators.any? &&
      tickets.select! { |t| any_operators.find { |(o,k,v)| t[k].to_s.public_send(o, v) } }

    page(tickets, root: "tickets")
  end
end
