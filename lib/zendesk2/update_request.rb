# frozen_string_literal: true
class Zendesk2::UpdateRequest
  include Zendesk2::Client

  request_method :put
  request_path do |_r| "/requests/#{id}.json" end
  request_params do |r| { 'request' => r.params } end

  def request_id
    @_request_id ||= params.delete('id')
  end

  def mock(params = {})
    ticket = find!(:tickets, request_id)
    ticket.merge!(params)

    mock_response('request' => ticket)
  end
end
