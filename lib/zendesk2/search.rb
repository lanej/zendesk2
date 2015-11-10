class Zendesk2::Search < Zendesk2::Request
  request_method :get
  request_body { |r| { query: r.query } }
  request_path { |_| "/search.json" }

  page_params!

  attr_reader :query

  def _mock(query, params={})
    @query = query
    setup(params)
    mock
  end

  def _real(query, params={})
    @query = query
    setup(params)
    real
  end

  def mock
    terms = Hash[query.split(" ").map { |t| t.split(":") }]
    type  = terms.delete("type")

    collection = if type.nil?
                   service.data.values
                 else
                   service.data[pluralize(type).to_sym]
                 end

    results = collection.values.select { |v| terms.all?{ |term, condition| v[term].to_s == condition.to_s } }

    page(results, params: {"query" => query}, root: "results")
  end
end
