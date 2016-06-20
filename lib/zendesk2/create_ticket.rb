# frozen_string_literal: true
class Zendesk2::CreateTicket
  include Zendesk2::Request

  request_method :post
  request_path { |_| '/tickets.json' }
  request_body { |r| { 'ticket' => r.ticket_params } }

  def self.accepted_attributes
    %w(external_id via priority requester requester_id submitter_id assignee_id organization_id subject description
       custom_fields recipient status collaborator_ids tags)
  end

  def ticket_params
    Cistern::Hash.slice(params.fetch('ticket'), *self.class.accepted_attributes)
  end

  def mock
    create_params = ticket_params

    Zendesk2.blank?(create_params['description']) &&
      error!(:invalid, details: { 'base' => [{ 'description' => 'Description: cannot be blank' }] })

    requester_id = create_params.delete('requester_id')

    set_requester(create_params.delete('requester'), create_params)
    custom_fields = get_custom_fields(create_params.delete('custom_fields') || [])

    identity = cistern.serial_id

    record = {
      'id'               => identity,
      'url'              => url_for("/tickets/#{identity}.json"),
      'created_at'       => Time.now.iso8601,
      'updated_at'       => Time.now.iso8601,
      'priority'         => nil,
      'collaborator_ids' => [],
      'custom_fields'    => custom_fields,
    }.merge(create_params)

    record['requester_id'] ||= (requester_id && requester_id.to_i) || cistern.current_user['id']
    record['submitter_id'] = cistern.current_user['id'].to_i

    requester = cistern.data[:users][record['requester_id'].to_i]

    record['organization_id'] ||= requester['organization_id'] if requester

    cistern.data[:tickets][identity] = record

    mock_response('ticket' => record)
  end

  private

  def set_requester(requester, create_params)
    return unless requester

    Zendesk2.blank?(requester['name']) &&
      error!(:invalid, details: {
               'requester' => [
                 {
                   'description' => 'Requester Name:  is too short (minimum is 1 characters)',
                 },
               ],
             })

    known_user = cistern.users.search(email: requester['email']).first

    user_id = (known_user && known_user.identity) || cistern.create_user('user' => requester).body['user']['id']

    create_params['requester_id'] = user_id.to_i
  end

  def get_custom_fields(requested_custom_fields)
    custom_fields = requested_custom_fields.map do |cf|
      field_id = cf['id'].to_i

      if cistern.data[:ticket_fields][field_id]
        { 'id' => field_id, 'value' => cf['value'] }
      end
    end.compact

    cistern.data[:ticket_fields].each do |field_id, _field|
      requested_custom_fields.find { |cf| cf['id'] == field_id } ||
        custom_fields << { 'id' => field_id, 'value' => nil }
    end

    custom_fields
  end
end
