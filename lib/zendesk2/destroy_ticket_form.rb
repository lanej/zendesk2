# frozen_string_literal: true
class Zendesk2::DestroyTicketForm
  include Zendesk2::Request

  request_method :delete
  request_path { |r| "/ticket_forms/#{r.ticket_form_id}.json" }

  def ticket_form_id
    params.fetch('ticket_form').fetch('id')
  end

  def mock
    delete!(:ticket_forms, ticket_form_id)

    mock_response(nil)
  end
end
