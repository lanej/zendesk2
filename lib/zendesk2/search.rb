# frozen_string_literal: true
class Zendesk2::Search
  include Zendesk2::Request

  request_method :get
  request_body do |r| { query: r.query } end
  request_path do |_| '/search.json' end

  page_params!

  attr_reader :query

  def _mock(query, params = {})
    @query = query
    setup(params)
    mock
  end

  def _real(query, params = {})
    @query = query
    setup(params)
    real
  end

  def mock
    terms = Hash[query.split(' ').map { |t| t.split(':') }]
    type  = terms.delete('type')

    collection = if type.nil?
                   cistern.data.values
                 else
                   cistern.data[pluralize(type).to_sym]
                 end

    results = collection.values.select { |v| terms.all? { |term, condition| v[term].to_s == condition.to_s } }

    page(results, params: { 'query' => query }, root: 'results')
  end
end
