class Zendesk2::Real

  attr_accessor :username, :url, :token, :logger, :jwt_token, :last_request

  def initialize(options={})
    @url = if url = options[:url] || Zendesk2.defaults[:url]
             URI.parse(url).to_s
           end

    @logger   = options[:logger]   || Logger.new(nil)
    adapter   = options[:adapter]  || Faraday.default_adapter
    @username = options[:username] || Zendesk2.defaults[:username]
    @token    = options.fetch(:token, Zendesk2.defaults[:token])
    password  = options[:password] || Zendesk2.defaults[:password]

    service_options = options[:service_options] || {}

    @auth_token  = password || @token
    @username   += "/token" if @auth_token == @token
    @jwt_token   = options[:jwt_token]

    raise "Missing required options: :url" unless @url
    raise "Missing required options: :username" unless @username
    raise "Missing required options: :password or :token" unless password || @token

    @service = Faraday.new({url: @url}.merge(service_options)) do |connection|
      # response
      connection.use Faraday::Request::BasicAuthentication, @username, @auth_token
      connection.use Faraday::Response::RaiseError
      connection.response :json, content_type: /\bjson/

      # request
      connection.request :multipart
      connection.request :json

      # idempotency
      connection.request :retry,
        :max                 => 30,
        :interval            => 1,
        :interval_randomness => 0.2,
        :backoff_factor      => 2

      # rate limit
      connection.use Zendesk2::RateLimit, logger: @logger

      connection.use Zendesk2::Logger, @logger
      connection.adapter(*adapter)
    end
  end

  def request(options={})
    method  = options[:method] || :get
    url     = options[:url] || File.join(@url, "/api/v2", options[:path])
    params  = options[:params] || {}
    body    = options[:body]
    headers = {"User-Agent" => Zendesk2::USER_AGENT}.merge(options[:headers] || {})

    @service.send(method) do |req|
      req.url(url)
      req.headers.merge!(headers)
      req.params.merge!(params)
      req.body = @last_request = body
    end
  rescue Faraday::ConnectionFailed
    raise
  rescue Faraday::ErrorError => e
    raise Zendesk2::Error.new(e)
  end
end
