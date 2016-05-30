# frozen_string_literal: true
class Zendesk2::DestroyView
  include Zendesk2::Request

  request_method :delete
  request_path do |r| "/views/#{r.view_id}.json" end

  def view_id
    @_view_id ||= params.fetch('view').fetch('id')
  end

  def mock
    delete!(:views, view_id)

    mock_response(nil)
  end
end
