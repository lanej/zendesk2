class Zendesk2::DestroyView < Zendesk2::Request
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
