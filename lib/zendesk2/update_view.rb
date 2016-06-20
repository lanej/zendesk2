# frozen_string_literal: true
class Zendesk2::UpdateView
  include Zendesk2::Request

  request_method :put
  request_path { |r| "/views/#{r.view_id}.json" }
  request_body { |r| { 'view' => r.view_params } }

  def self.accepted_attributes
    Zendesk2::CreateView.accepted_attributes
  end

  def view_params
    Cistern::Hash.slice(params.fetch('view'), *self.class.accepted_attributes)
  end

  def view_id
    params.fetch('view').fetch('id')
  end

  def mock
    body = find!(:views, view_id)

    update_params = view_params

    output = update_params.delete('output') || {}
    columns = (output['columns'] || []).inject([]) do |a, e|
      a + [{ 'id' => e, 'name' => Zendesk2::CreateView.view_columns.fetch(c) }]
    end

    body['updated_at'] = Time.now.iso8601

    if columns.any?
      body['execution'] = {
        'columns' => columns,
        'fields'        => columns,
        'custom_fields' => [],
      }
    end

    body['execution']['conditions'] = Cistern::Hash.slice(body, 'any', 'all')

    group_params = Cistern::Hash.slice(body, 'group_by', 'group_order').merge(
      Cistern::Hash.slice(update_params, 'group_by', 'group_order')
    )

    body.merge!(group_params)['group'] = {
      'id'    => group_params['group_by'],
      'order' => group_params['group_order'],
      'title' => (group_params['group_by'] && group_params['group_by'].to_s.upcase),
    }

    sort_params = Cistern::Hash.slice(body, 'sort_by', 'sort_order').merge(
      Cistern::Hash.slice(update_params, 'sort_by', 'sort_order')
    )

    body.merge!(sort_params)['sort'] = {
      'id'    => sort_params['sort_by'],
      'order' => sort_params['sort_order'],
      'title' => (sort_params['sort_by'] && sort_params['sort_by'].to_s.upcase),
    }

    body.merge!(Cistern::Hash.slice(update_params, 'title', 'active'))
    cistern.data[:views][view_id] = body

    mock_response('view' => body)
  end
end
