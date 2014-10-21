class Zendesk2::Client::Requestx
  def self.request_method(request_method=nil)
    @request_method ||= request_method
  end

  def self.request_params(&block)
    @request_params ||= block
  end

  def self.request_body(request_body=nil)
    @request_body ||= request_body
  end

  def self.request_path(&block)
    @request_path ||= block
  end

  def self.page_params!
    @page_params = true
  end

  def self.page_params
    @page_params
  end

  def page_params!(options)
    if url = options["url"]
      Faraday::NestedParamsEncoder.decode(URI.parse(url).query)
    else
      Cistern::Hash.stringify_keys(options)
    end
  end

  def page_params
    @page_params
  end

  def request_params(params)
    page_params!(params) if page_params
    self.class.request_params ? self.class.request_params.call(params) : {}
  end

  def request_path(params)
    case (generator = self.class.request_path)
    when Proc then
    when String then
    else raise ArgumentError.new("Couldn't generate request_path from #{generator.inspect}")
    end
  end

  def request_body(params)
    case (generator = self.class.request_body)
    when Proc then
      generator.call(*params)
    when String then
      generator % params
    else nil
    end
  end

  def data
    self.service.data
  end

  def real(params={})
    service.request(:method => self.class.request_method,
                    :path   => self.request_path(params),
                    :body   => self.request_body(params),
                    :url    => params.delete("url"),
                    :params => self.request_params(params),
                   )
  end

  def real_request(params={})
    request({
      :method => self.class.request_method,
      :path   => self.request_path(params),
      :body   => self.request_body(params),
    }.merge(Cistern::Hash.slice(params, :method, :path, :body, :headers)))
  end

  def mock_response(params={})
    response({
      :method => self.class.request_method,
      :path   => self.request_path(params),
      :body   => self.request_body(params),
    }.merge(Cistern::Hash.slice(params, :method, :path, :body, :headers)))
  end

  def resources(collection, options={})
    filter    = options[:filter]
    resources = service.data[collection].values
    resources = filter.call(resources) if filter
    count     = resources.size
    root      = options[:root] || collection

    mock_response({
      :body => {
        root    => resources,
        "count" => count,
      },
    }.merge(options[:params] || {}))
  end

  def page(collection, _params, options={})
    params = page_params!(_params)

    page_size  = (params.delete("per_page") || 50).to_i
    page_index = (params.delete("page") || 1).to_i
    root       = options.fetch(:root) { !collection.is_a?(Array) && collection.to_s }
    path       = options[:path] || request_path(params)

    offset     = (page_index - 1) * page_size

    resources   = collection.is_a?(Array) ? collection : service.data[collection.to_sym].values
    count       = resources.size
    total_pages = (count / page_size) + 1

    next_page = if page_index < total_pages
                  url_for(path, query: {page: page_index + 1, per_page: page_size}.merge(params))
                end
    previous_page = if page_index > 1
                      url_for(path, query: {page: page_index - 1, per_page: page_size}.merge(params))
                    end

    resource_page = resources.slice(offset, page_size)

    body = {
      root            => resource_page,
      "count"         => count,
      "next_page"     => next_page,
      "previous_page" => previous_page,
    }

    response(
      :body => body,
      :path => path
    )
  end

  def find!(collection, identity, options={})
    if resource = self.service.data[collection][identity.to_s] || self.service.data[collection][identity.to_i]
      resource
    else
      error!(options[:error] || :not_found, options)
    end
  end

  def delete!(collection, identity, options={})
    self.service.data[collection].delete(identity.to_s) ||
      error!(options[:error] || :not_found, options[:params])
  end

  def error!(type, params, options={})
    status, body = self.class.error_map[type]
    body.merge!("details" => options[:details]) if options[:details]

    response(
      :path   => self.request_path(params),
      :status => status,
      :body   => body,
    )
  end

  def response(options={})
    method = options[:method] || :get
    status = options[:status] || 200
    path   = options[:path]
    body   = options[:body]

    url = options[:url] || url_for(path)

    env = Faraday::Env.new(method, body, url, nil, {}, nil, nil, {}, nil, {"Content-Type"  => "application/json; charset=utf-8"}, status)

    Faraday::Response::RaiseError.new.on_complete(env) || Faraday::Response.new(env)
  rescue Faraday::Error::ClientError => e
    raise Zendesk2::Error.new(e)
  end
end
