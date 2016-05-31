# frozen_string_literal: true
class Zendesk2::GetUserField
  include Zendesk2::Request

  request_path do |r| "/user_fields/#{r.user_field_id}.json" end
  request_method :get

  def user_field_id
    params.fetch('user_field').fetch('id')
  end

  def mock
    mock_response('user_field' => find!(:user_fields, user_field_id))
  end
end
