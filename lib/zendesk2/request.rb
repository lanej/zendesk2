class Zendesk2::Request
  def self.request_method(request_method=nil)
    @request_method ||= request_method
  end

  def self.request_params(&block)
    @request_params ||= block
  end

  def self.request_body(&block)
    @request_body ||= block
  end

  def self.request_path(&block)
    @request_path ||= block
  end

  def self.page_params!
    @page_params = true
  end

  def self.page_params?
    @page_params
  end

  def self.error_map
    @@error_map ||= {
      :invalid => [422, {
        "error"       => "RecordInvalid",
        "description" => "Record validation errors",
      }],
      :not_found => [404, {
        "error"       => "RecordNotFound",
        "description" => "Not found",
      }],
    }
  end

  attr_reader :params

  def setup(params)
    @params = Cistern::Hash.stringify_keys(params)
  end

  def _mock(params={})
    setup(params)
    mock
  end

  def _real(params={})
    setup(params)
    real
  end

  def page_params!(options)
    page_params = if url = options.delete("url")
                    Faraday::NestedParamsEncoder.decode(URI.parse(url).query)
                  else
                    Cistern::Hash.stringify_keys(options)
                  end
    Cistern::Hash.slice(page_params, "per_page", "page", "query")
  end

  def page_params?
    self.class.page_params?
  end

  def request_params
    page_params = if page_params?
                    page_params!(self.params)
                  end

    if self.class.request_params
      self.class.request_params.call(self)
    else
      page_params
    end
  end

  def request_path
    case (generator = self.class.request_path)
    when Proc then
      generator.call(self)
    else raise ArgumentError.new("Couldn't generate request_path from #{generator.inspect}")
    end
  end

  def request_body
    case (generator = self.class.request_body)
    when Proc then
      generator.call(self)
    when NilClass then nil
    else raise("Invalid request body generator: #{generator.inspect}")
    end
  end

  def pluralize(word)
    pluralized = word.dup
    [[/y$/, 'ies'], [/$/, 's']].find{|regex, replace| pluralized.gsub!(regex, replace) if pluralized.match(regex)}
    pluralized
  end

  def data
    self.service.data
  end

  def html_url_for(path)
    File.join(service.url, path.to_s)
  end

  def url_for(path, options={})
    URI.parse(
      File.join(service.url, "/api/v2", path.to_s)
    ).tap do |uri|
      if query = options[:query]
        uri.query = Faraday::NestedParamsEncoder.encode(query)
      end
    end.to_s
  end

  def real(params={})
    service.request(:method => self.class.request_method,
                    :path   => self.request_path,
                    :body   => self.request_body,
                    :url    => params["url"],
                    :params => self.request_params,
                   )
  end

  def real_request(params={})
    request({
      :method => self.class.request_method,
      :path   => self.request_path(params),
      :body   => self.request_body(params),
    }.merge(cistern::hash.slice(params, :method, :path, :body, :headers)))
  end

  def mock_response(body, options={})
    response(
      :method        => self.class.request_method,
      :path          => options[:path]    || self.request_path,
      :request_body  => self.request_body,
      :response_body => body,
      :headers       => options[:headers] || {},
      :status        => options[:status]  || 200,
      :params        => options[:params]  || self.request_params,
    )
  end

  def find!(collection, identity, options={})
    if resource = self.service.data[collection][identity.to_i]
      resource
    else
      error!(options[:error] || :not_found, options)
    end
  end

  def delete!(collection, identity, options={})
    self.service.data[collection].delete(identity.to_i) ||
      error!(options[:error] || :not_found, options)
  end

  def error!(type, options={})
    status, body = self.class.error_map[type]
    body.merge!("details" => options[:details]) if options[:details]

    response(
      :path   => self.request_path,
      :status => status,
      :body   => body,
    )
  end

  def resources(collection, options={})
    page = collection.is_a?(Array) ? collection : service.data[collection.to_sym].values
    root = options.fetch(:root) { !collection.is_a?(Array) && collection.to_s }

    mock_response(
      root    => page,
      "count" => page.size,
    )
  end

  def page(collection, options={})
    url_params = options[:params] || params
    page_params = page_params!(params)

    page_size  = (page_params.delete("per_page") || 50).to_i
    page_index = (page_params.delete("page") || 1).to_i
    root       = options.fetch(:root) { !collection.is_a?(Array) && collection.to_s }
    path       = options[:path] || request_path

    offset     = (page_index - 1) * page_size

    resources   = collection.is_a?(Array) ? collection : service.data[collection.to_sym].values
    count       = resources.size
    total_pages = (count / page_size) + 1

    next_page = if page_index < total_pages
                  url_for(path, query: {"page" => page_index + 1, "per_page" =>  page_size}.merge(url_params))
                end
    previous_page = if page_index > 1
                      url_for(path, query: {"page" => page_index - 1, "per_page" =>  page_size}.merge(url_params))
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

  # @fixme
  # id values are validate for format / type
  #
  # {
  #   "error": {
  #     "title": "Invalid attribute",
  #     "message": "You passed an invalid value for the id attribute. must be an integer"
  #   }
  # }
  # @note
  #
  # \@request_body is special because it's need for spec assertions but
  # {Faraday::Env} replaces the request body with the response body after
  # the request and the reference is lost
  def response(options={})
    body                 = options[:response_body] || options[:body]
    method               = options[:method]        || :get
    params               = options[:params]
    service.last_request = options[:request_body]
    status               = options[:status]        || 200

    path = options[:path]
    url  = options[:url] || url_for(path, query: params)

    request_headers  = {"Accept"       => "application/json"}
    response_headers = {"Content-Type" => "application/json; charset=utf-8"}

    # request phase
    # * :method - :get, :post, ...
    # * :url    - URI for the current request; also contains GET parameters
    # * :body   - POST parameters for :post/:put requests
    # * :request_headers

    # response phase
    # * :status - HTTP response status code, such as 200
    # * :body   - the response body
    # * :response_headers
    env = Faraday::Env.from(
      :method           => method,
      :url              => URI.parse(url),
      :body             => body,
      :request_headers  => request_headers,
      :response_headers => response_headers,
      :status           => status,
    )

    Faraday::Response::RaiseError.new.on_complete(env) ||
      Faraday::Response.new(env)
  rescue Faraday::Error::ClientError => e
    raise Zendesk2::Error.new(e)
  end
end
