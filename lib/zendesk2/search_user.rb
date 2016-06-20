# frozen_string_literal: true
class Zendesk2::SearchUser
  include Zendesk2::Request

  request_method :get
  request_path { '/search.json' }
  request_body { |r| { 'query' => r.query } }

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

    collection = searchable_collection(terms)

    compiled_terms = terms.inject({}) do |r, (term, raw_condition)|
      condition = if raw_condition.include?('*')
                    Regexp.compile(raw_condition.gsub('*', '.*'), Regexp::IGNORECASE)
                  else
                    raw_condition
                  end
      r.merge(term => condition)
    end

    munged_results = collection.select do |v|
      compiled_terms.all? do |term, condition|
        condition.is_a?(Regexp) ? condition.match(v[term.to_s]) : v[term.to_s].to_s == condition.to_s
      end
    end

    # return the unmunged data
    results = munged_results.map do |u|
      identities = data[:identities].values.select { |i| i['user_id'] == u['id'] }
      identity = identities.find { |i| i['type'] == 'email' && i['primary'] } ||
                 identities.find { |i| i['type'] == 'email' }
      u.merge!('email' => identity['value']) if identity
    end

    page(results, params: { 'query' => query }, root: 'results')
  end

  private

  def searchable_collection(terms)
    collection = data[:users].values

    # create a copy of each user mapped to a specific user identity
    collection = collection.map do |user|
      data[:identities].values.select { |i| i['type'] == 'email' && i['user_id'] == user['id'] }.map do |identity|
        user.merge('email' => identity['value'])
      end
    end.flatten

    # allow searching by organization name
    collection = collection.map do |user|
      organization = data[:organizations][user['organization_id'].to_i]
      organization ? user.merge('organization' => organization['name']) : user
    end

    # organization name is fuzzy matched
    organization_name = terms.delete('organization')
    organization_name && terms['organization'] = "*#{organization_name}*"

    collection
  end
end
