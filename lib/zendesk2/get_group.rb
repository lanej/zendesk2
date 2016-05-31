# frozen_string_literal: true
class Zendesk2::GetGroup
  include Zendesk2::Request

  request_method :get
  request_path do |r| "/groups/#{r.group_id}.json" end

  def group_id
    @_group_id ||= params.fetch('group').fetch('id')
  end

  def mock
    mock_response('group' => find!(:groups, group_id))
  end
end
