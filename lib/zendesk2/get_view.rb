# frozen_string_literal: true
class Zendesk2::GetView
  include Zendesk2::Request

  request_method :get
  request_path do |r| "/views/#{r.view_id}.json" end

  def view_id
    params.fetch('view').fetch('id')
  end

  def mock
    mock_response('view' => find!(:views, view_id))
  end
end
