# frozen_string_literal: true
class Zendesk2::CreateView
  include Zendesk2::Request

  request_method :post
  request_path do |_| '/views.json' end
  request_body do |r| { 'view' => r.view_params } end

  def self.accepted_attributes
    %w(title all any active output restriction)
  end

  def self.view_columns
    @_view_columns ||= {
      'assigned'           => 'Assigned date',
      'assignee'           => 'Assignee',
      'brand'              => 'Brand',
      'created'            => 'Request date',
      'description'        => 'Subject',
      'due_date'           => 'Due Date',
      'group'              => 'Group',
      'locale_id'          => 'Requester language',
      'nice_id'            => 'ID',
      'organization'       => 'Organization',
      'priority'           => 'Priority',
      'requester'          => 'Requester',
      'satisfaction_score' => 'Satisfaction',
      'score'              => 'Score',
      'solved'             => 'Solved date',
      'status'             => 'Status',
      'submitter'          => 'Submitter',
      'ticket_form'        => 'Ticket form',
      'type'               => 'Ticket type',
      'updated'            => 'Latest update',
      'updated_assignee'   => 'Latest update by assignee',
      'updated_by_type'    => 'Latest updater type (agent/end-user)',
      'updated_requester'  => 'Latest update by requester',
    }.freeze
  end

  def view_params
    Cistern::Hash.slice(params.fetch('view'), *self.class.accepted_attributes)
  end

  def mock
    create_params = view_params

    if Zendesk2.blank?(create_params['title'])
      error!(:invalid, details: { 'base' => [{ 'title' => 'Title: cannot be blank' }] })
    end

    if Array(create_params['any']).empty? && Array(create_params['all']).empty?
      error!(:invalid, details: { 'base' => ['Invalid conditions: You must select at least one condition'] })
    end

    identity = cistern.serial_id

    output = view_params.delete('output') || {}
    columns = (output['columns'] || []).inject([]) { |a, e|
      a << { 'id' => e, 'name' => self.class.view_columns.fetch(e) }
    }

    record = {
      'id'               => identity,
      'url'              => url_for("/views/#{identity}.json"),
      'created_at'       => Time.now.iso8601,
      'updated_at'       => Time.now.iso8601,
      'active'           => true,
      'execution'        => {
        'columns'       => columns,
        'fields'        => columns,
        'custom_fields' => [],
        'group_by'      => create_params['group_by'],
        'group_order'   => create_params['group_order'],
        'sort_by'       => create_params['sort_by'],
        'sort_order'    => create_params['sort_order'],
        'sort' => {
          'id'    => create_params['sort_by'],
          'order' => create_params['sort_order'],
          'title' => (create_params['sort_by'] && create_params['sort_by'].to_s.upcase),
        },
        'group' => {
          'id'    => create_params['group_by'],
          'order' => create_params['group_order'],
          'title' => (create_params['group_by'] && create_params['group_by'].to_s.upcase),
        },
      },
      'conditions' => {
        'any' => Array(create_params['any']),
        'all' => Array(create_params['all']),
      },
    }.merge(create_params)

    cistern.data[:views][identity] = record

    mock_response('view' => record)
  end
end
