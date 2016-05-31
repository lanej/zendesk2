# frozen_string_literal: true
class Zendesk2::DestroyGroup
  include Zendesk2::Request

  request_method :delete
  request_path do |r| "/groups/#{r.group_id}.json" end

  def group_id
    params.fetch('group').fetch('id')
  end

  def mock
    find!(:groups, group_id, params)['deleted'] = true

    mock_response(nil)
  end
end
