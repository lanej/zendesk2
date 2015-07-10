class Zendesk2::Client::DestroyView < Zendesk2::Client::Request
  request_method :delete
  request_path { |r| "/views/#{r.view_id}.json" }

  def view_id
    @_view_id ||= params.fetch("view").fetch("id")
  end

  def mock
    self.delete!(:views, view_id)

    mock_response(nil)
  end
end
