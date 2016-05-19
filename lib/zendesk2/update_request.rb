class Zendesk2::UpdateRequest
  include Zendesk2::Client

  request_method :put
  request_path { |r| "/requests/#{id}.json" }
  request_params { |r| { "request" => r.params } }

  def request_id
    @_request_id ||= params.delete("id")
  end

  def mock(params={})
    ticket = find!(:tickets, request_id)
    ticket.merge!(params)

    mock_response("request" => ticket)
  end
end
