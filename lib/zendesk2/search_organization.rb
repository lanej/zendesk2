# frozen_string_literal: true
class Zendesk2::SearchOrganization
  include Zendesk2::Request

  request_method :get
  request_path do '/search.json' end
  request_body do |r| { 'query' => r.query } end

  attr_reader :query

  page_params!

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
    terms.delete('type') # context already provided

    collection = data[:organizations].values

    # organization name is fuzzy matched
    organization_name = terms.delete('name')
    organization_name && terms['name'] = "*#{organization_name}*"

    compiled_terms = terms.inject({}) { |r, (term, raw_condition)|
      condition = if raw_condition.include?('*')
                    Regexp.compile(raw_condition.gsub('*', '.*'), Regexp::IGNORECASE)
                  else
                    raw_condition
                  end
      r.merge(term => condition)
    }

    results = collection.select { |v|
      compiled_terms.all? do |term, condition|
        condition.is_a?(Regexp) ? condition.match(v[term.to_s]) : v[term.to_s].to_s == condition.to_s
      end
    }

    page(results, params: { 'query' => query }, root: 'results')
  end
end
