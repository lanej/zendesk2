# frozen_string_literal: true
class Zendesk2::UpdateUserField
  include Zendesk2::Request

  request_method :put
  request_path do |r| "/user_fields/#{r.user_field_id}.json" end

  def user_field_id
    params.fetch('user_field').fetch('id')
  end

  def user_field_params
    Cistern::Hash.slice(params.fetch('user_field'), *Zendesk2::CreateUserField.accepted_attributes)
  end

  def mock
    mock_response('user_field' => find!(:user_fields, user_field_id).merge!(user_field_params))
  end
end
