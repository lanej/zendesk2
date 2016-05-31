# frozen_string_literal: true
class Zendesk2::CreateGroup
  include Zendesk2::Request

  request_method :post
  request_path do |_| '/groups.json' end
  request_body do |r| { 'group' => r.group_params } end

  def self.accepted_attributes
    %w(name)
  end

  def group_params
    @_group_params ||= Cistern::Hash.slice(params.fetch('group'), *self.class.accepted_attributes)
  end

  def mock(_params = {})
    identity = cistern.serial_id

    record = {
      'id'         => identity,
      'url'        => url_for("/groups/#{identity}.json"),
      'created_at' => Time.now.iso8601,
      'updated_at' => Time.now.iso8601,
      'deleted'    => false,
    }.merge(group_params)

    data[:groups][identity] = record

    mock_response({ 'group' => record }, { status: 201 })
  end
end
