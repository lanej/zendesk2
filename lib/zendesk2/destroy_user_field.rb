# frozen_string_literal: true
class Zendesk2::DestroyUserField
  include Zendesk2::Request

  request_method :delete
  request_path { |r| "/user_fields/#{r.user_field_id}.json" }

  def user_field_id
    params.fetch('user_field').fetch('id')
  end

  def mock
    mock_response('user_field' => delete!(:user_fields, user_field_id))
  end
end
