# frozen_string_literal: true
class Zendesk2::Search
  include Zendesk2::Request

  request_method :get
  request_body { |r| { query: r.query } }
  request_path { |_| '/search.json' }

  page_params!

  attr_reader :query

  def call(query, params)
    @query = query
    super(params)
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
